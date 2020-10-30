import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/cart/cart.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/repositories/size.dart';
import 'package:refashioned_app/repositories/user_addresses.dart';
import 'package:refashioned_app/screens/authorization/authorization_sheet.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_navigation.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/tab_view.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/components/webview_page.dart';
import 'package:refashioned_app/screens/delivery/components/delivery_options_panel.dart';
import 'package:refashioned_app/screens/delivery/delivery_navigator.dart';
import 'package:refashioned_app/screens/delivery/pages/map_page.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';

//Используемый паттерн: https://medium.com/coding-with-flutter/flutter-case-study-multiple-navigators-with-bottomnavigationbar-90eb6caa6dbf
//Github: https://github.com/bizz84/nested-navigation-demo-flutter

final navigatorKeys = {
  BottomTab.home: GlobalKey<NavigatorState>(),
  BottomTab.catalog: GlobalKey<NavigatorState>(),
  BottomTab.cart: GlobalKey<NavigatorState>(),
  BottomTab.profile: GlobalKey<NavigatorState>(),
  BottomTab.marketPlace: GlobalKey<NavigatorState>(),
};

class TabSwitcher extends StatefulWidget {
  final ValueNotifier<BottomTab> currentTab;
  final Function(Order, Function()) onCheckoutPush;
  final Function(Seller, Function()) onSellerReviewsPush;

  const TabSwitcher({
    Key key,
    @required this.currentTab,
    @required this.onCheckoutPush,
    @required this.onSellerReviewsPush,
  }) : super(key: key);

  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  bool selected;
  bool deliveryTypesSelectorOpened;
  bool sellerReviewsOpened;

  GetUserAddressesRepository getUserAddressesRepository;

  @override
  initState() {
    widget.currentTab.addListener(tabListener);
    selected = false;
    deliveryTypesSelectorOpened = false;
    sellerReviewsOpened = false;

    getUserAddressesRepository = GetUserAddressesRepository();

    super.initState();
  }

  tabListener() async {
    switch (widget.currentTab.value) {
      case BottomTab.home:
      case BottomTab.catalog:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
      case BottomTab.cart:
        Provider.of<CartRepository>(context, listen: false).refresh();
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;
      case BottomTab.profile:
        final isAuthorized = await BaseRepository.isAuthorized();
        SystemChrome.setSystemUIOverlayStyle(isAuthorized ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
        break;
      default:
        break;
    }
  }

  onTabRefresh() {
    final canPop = navigatorKeys[widget.currentTab.value]?.currentState?.canPop() ?? false;

    if (canPop) navigatorKeys[widget.currentTab.value].currentState.pushNamedAndRemoveUntil('/', (route) => false);

    if (widget.currentTab.value == BottomTab.cart) Provider.of<CartRepository>(context, listen: false).refresh();

    if (widget.currentTab.value == BottomTab.catalog || widget.currentTab.value == BottomTab.home) {
      var topPanelController =
          Provider.of<TopPanelController>(navigatorKeys[widget.currentTab.value].currentContext, listen: false);
      topPanelController.needShow = true;
      topPanelController.needShowBack = false;
    }
  }

  _pushPageOnTop(
      {Widget page, Widget Function(BuildContext) builder, BuildContext context, bool slideUpFromBottom: false}) {
    if (slideUpFromBottom)
      Navigator.of(context ?? this.context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
            position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(animation),
            child: builder != null ? Builder(builder: builder) : page ?? SizedBox(),
          ),
        ),
      );
    else
      Navigator.of(context ?? this.context).push(
        CupertinoPageRoute(
          builder: builder ?? (context) => page ?? SizedBox(),
        ),
      );
  }

  pushInfoSheet(String infoUrl, String title) {
    return Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
            position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(animation),
            child: WebViewPage(
              initialUrl: infoUrl,
              title: title,
              webViewPageMode: WebViewPageMode.modalSheet,
            ))));
  }

  openPickUpAddressMap(PickPoint pickPoint) => _pushPageOnTop(
        slideUpFromBottom: true,
        page: MapPage(
          pickPoint: pickPoint,
          onClose: () => Navigator.of(context).pop(),
        ),
      );

  // onSellerReviewsPush(Seller seller, Function() callback) async {
  //   if (!sellerReviewsOpened) {
  //     sellerReviewsOpened = true;

  //     if (!await BaseRepository.isAuthorized()) {
  //       await showMaterialModalBottomSheet(
  //         expand: false,
  //         context: context,
  //         useRootNavigator: true,
  //         builder: (__, controller) => AuthorizationSheet(
  //           onAuthorizationCancel: (_) => callback?.call(),
  //           onAuthorizationDone: (_) => onSellerReviewsPush(seller, callback),
  //         ),
  //       );

  //       sellerReviewsOpened = false;
  //     } else {
  //       sellerReviewsOpened = false;

  //       await widget.onSellerReviewsPush(seller, callback);
  //     }
  //   }
  // }

  openDeliveryTypesSelector(
    BuildContext context,
    String id, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function() onFinish,
    Future<bool> Function(String, String) onSelect,
    SystemUiOverlayStyle originalOverlayStyle,
  }) async {
    if (!deliveryTypesSelectorOpened) {
      deliveryTypesSelectorOpened = true;

      if (!await BaseRepository.isAuthorized()) {
        await showMaterialModalBottomSheet(
          expand: false,
          context: context,
          useRootNavigator: true,
          builder: (__, controller) => AuthorizationSheet(
            onAuthorizationCancel: (_) async {
              if (originalOverlayStyle != null) SystemChrome.setSystemUIOverlayStyle(originalOverlayStyle);

              await onClose?.call();
            },
            onAuthorizationDone: (_) async {
              if (originalOverlayStyle != null) SystemChrome.setSystemUIOverlayStyle(originalOverlayStyle);

              await openDeliveryTypesSelector(
                context,
                id,
                deliveryTypes: deliveryTypes,
                onClose: onClose,
                onFinish: onFinish,
              );
            },
          ),
        );

        deliveryTypesSelectorOpened = false;
      } else {
        List<DeliveryType> types;
        List<UserAddress> userAddresses;

        if (deliveryTypes == null || deliveryTypes.isEmpty) {
          final deliveryTypesRepository = Provider.of<CartRepository>(context, listen: false);

          await deliveryTypesRepository.getCartItemDeliveryTypes(id);

          types = deliveryTypesRepository?.getDeliveryTypes?.response?.content;
        } else {
          types = deliveryTypes;
        }

        await getUserAddressesRepository.update();

        userAddresses = getUserAddressesRepository.response?.content ?? [];

        if (types != null && types.isNotEmpty) {
          await showMaterialModalBottomSheet(
            expand: false,
            context: context,
            useRootNavigator: true,
            builder: (context, controller) => DeliveryOptionsPanel(
              onPush: (deliveryType) {
                selected = true;

                Navigator.of(context).pop();

                _pushPageOnTop(
                  context: context,
                  slideUpFromBottom: true,
                  builder: (context) => DeliveryNavigator(
                    deliveryType: deliveryType,
                    userAddresses: userAddresses,
                    onClose: () async {
                      await onClose?.call();

                      Navigator.of(context).pop();

                      if (originalOverlayStyle != null) SystemChrome.setSystemUIOverlayStyle(originalOverlayStyle);
                    },
                    onSelect: (id) async {
                      final result = await onSelect?.call(deliveryType.deliveryOptions.first.deliveryCompany.id, id);

                      if (result) {
                        onFinish?.call();

                        await Future.delayed(const Duration(milliseconds: 400));

                        Navigator.of(context).pop();

                        if (originalOverlayStyle != null) SystemChrome.setSystemUIOverlayStyle(originalOverlayStyle);
                      }
                    },
                  ),
                );
              },
              options: types,
            ),
          );
        }

        if (!selected) onClose?.call();

        selected = false;

        deliveryTypesSelectorOpened = false;
      }
    }
  }

  @override
  void dispose() {
    widget.currentTab.removeListener(tabListener);
    widget.currentTab.dispose();

    getUserAddressesRepository.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async => !await navigatorKeys[widget.currentTab.value]?.currentState?.maybePop(),
        child: Stack(
          children: <Widget>[
            TabView(
              BottomTab.home,
              widget.currentTab,
              navigatorKey: navigatorKeys[BottomTab.home],
              onTabRefresh: onTabRefresh,
              pushPageOnTop: (page) => _pushPageOnTop(page: page),
              openPickUpAddressMap: openPickUpAddressMap,
              openDeliveryTypesSelector: openDeliveryTypesSelector,
              onCheckoutPush: widget.onCheckoutPush,
              onSellerReviewsPush: widget.onSellerReviewsPush,
            ),
            TabView(
              BottomTab.catalog,
              widget.currentTab,
              navigatorKey: navigatorKeys[BottomTab.catalog],
              pushPageOnTop: (page) => _pushPageOnTop(page: page),
              onTabRefresh: onTabRefresh,
              openPickUpAddressMap: openPickUpAddressMap,
              openDeliveryTypesSelector: openDeliveryTypesSelector,
              onCheckoutPush: widget.onCheckoutPush,
              onSellerReviewsPush: widget.onSellerReviewsPush,
              openInfoWebViewBottomSheet: pushInfoSheet,
            ),
            TabView(
              BottomTab.cart,
              widget.currentTab,
              navigatorKey: navigatorKeys[BottomTab.cart],
              onTabRefresh: onTabRefresh,
              pushPageOnTop: (page) => _pushPageOnTop(page: page),
              openPickUpAddressMap: openPickUpAddressMap,
              openDeliveryTypesSelector: openDeliveryTypesSelector,
              onCheckoutPush: widget.onCheckoutPush,
              onSellerReviewsPush: widget.onSellerReviewsPush,
            ),
            TabView(
              BottomTab.profile,
              widget.currentTab,
              navigatorKey: navigatorKeys[BottomTab.profile],
              onTabRefresh: onTabRefresh,
              pushPageOnTop: (page) => _pushPageOnTop(page: page),
              openPickUpAddressMap: openPickUpAddressMap,
              openDeliveryTypesSelector: openDeliveryTypesSelector,
              onCheckoutPush: widget.onCheckoutPush,
              onSellerReviewsPush: widget.onSellerReviewsPush,
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: BottomNavigation(
                widget.currentTab,
                () => {
                  BaseRepository.isAuthorized().then((isAuthorized) {
                    if (isAuthorized) {
                      _pushPageOnTop(
                          slideUpFromBottom: true,
                          page: ChangeNotifierProvider<SizeRepository>(
                            create: (_) => SizeRepository(),
                            builder: (context, _) => MarketplaceNavigator(
                              onClose: Navigator.of(context).pop,
                              onProductCreated: (productData) {
                                widget.currentTab.value = BottomTab.profile;
                                var profileProductsRepository =
                                    Provider.of<ProfileProductsRepository>(this.context, listen: false);
                                profileProductsRepository.response = null;
                                profileProductsRepository.startLoading();
                                var addProductRepository = AddProductRepository();
                                addProductRepository.addListener(() {
                                  if (addProductRepository.isLoaded) {
                                    profileProductsRepository
                                      ..response = null
                                      ..getProducts();
                                    if (productData.photos.length > 1) {
                                      addProductRepository.addOtherPhotos(productData);
                                    }
                                  }
                                });
                                addProductRepository.addProduct(productData);
                                Navigator.of(context).pop();
                              },
                              openInfoWebViewBottomSheet: pushInfoSheet,
                            ),
                          ));
                    } else
                      showMaterialModalBottomSheet(
                        expand: false,
                        context: context,
                        useRootNavigator: true,
                        builder: (context, controller) => AuthorizationSheet(),
                      );
                  })
                },
                onTabRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
