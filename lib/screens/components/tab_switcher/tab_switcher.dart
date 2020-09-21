import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/repositories/size.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/repositories/user_addresses.dart';
import 'package:refashioned_app/screens/authorization/authorization_sheet.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_navigation.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/tab_view.dart';
import 'package:refashioned_app/screens/components/scaffold/components/collect_widgets_data.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/delivery/components/delivery_options_panel.dart';
import 'package:refashioned_app/screens/delivery/delivery_navigator.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';

//Используемый паттерн: https://medium.com/coding-with-flutter/flutter-case-study-multiple-navigators-with-bottomnavigationbar-90eb6caa6dbf
//Github: https://github.com/bizz84/nested-navigation-demo-flutter

class TabSwitcher extends StatefulWidget {
  final BottomTab initialTab;

  ValueNotifier<BottomTab> currentTab;

  TabSwitcher({this.initialTab: BottomTab.catalog});

  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  WidgetData bottomNavWidgetData;

  SizesProvider sizesProvider;

  bool selected;

  @override
  initState() {
    sizesProvider = Provider.of<SizesProvider>(context, listen: false);

    bottomNavWidgetData = sizesProvider.getData("bottomNav") ?? WidgetData.create("bottomNav");

    widget.currentTab = ValueNotifier(widget.initialTab);

    widget.currentTab.addListener(tabListener);

    selected = false;

    super.initState();
  }

  tabListener() {
    switch (widget.currentTab.value) {
      case BottomTab.home:
      case BottomTab.catalog:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
      case BottomTab.cart:
      case BottomTab.profile:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;
    }
  }

  onTabRefresh() {
    final canPop = navigatorKeys[widget.currentTab.value]?.currentState?.canPop() ?? false;

    if (canPop)
      navigatorKeys[widget.currentTab.value]
          .currentState
          .pushNamedAndRemoveUntil('/', (route) => false);

    if (widget.currentTab.value == BottomTab.catalog || widget.currentTab.value == BottomTab.home) {
      var topPanelController = Provider.of<TopPanelController>(
          navigatorKeys[widget.currentTab.value].currentContext,
          listen: false);
      topPanelController.needShow = true;
      topPanelController.needShowBack = false;
    }
  }

  pushPageOnTop(Widget page) =>
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => page));

  openDeliveryTypesSelector(
    BuildContext context,
    String id, {
    List<DeliveryType> deliveryTypes,
    PickPoint pickUpAddress,
    Function() onClose,
    Function(String, String) onFinish,
    SystemUiOverlayStyle originalOverlayStyle,
  }) async {
    if (!await BaseRepository.isAuthorized()) {
      showCupertinoModalBottomSheet(
        backgroundColor: Colors.white,
        expand: false,
        context: context,
        useRootNavigator: true,
        builder: (__, controller) => AuthorizationSheet(
          onAuthorizationCancel: (_) async {
            if (originalOverlayStyle != null)
              SystemChrome.setSystemUIOverlayStyle(originalOverlayStyle);

            await onClose?.call();
          },
          onAuthorizationDone: (_) async {
            if (originalOverlayStyle != null)
              SystemChrome.setSystemUIOverlayStyle(originalOverlayStyle);

            await openDeliveryTypesSelector(
              context,
              id,
              deliveryTypes: deliveryTypes,
              pickUpAddress: pickUpAddress,
              onClose: onClose,
              onFinish: onFinish,
            );
          },
        ),
      );
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

      final userAddressesRepository = GetUserAddressesRepository();

      await userAddressesRepository.update();

      userAddresses = userAddressesRepository.response?.content ?? [];

      if (types != null && types.isNotEmpty) {
        HapticFeedback.lightImpact();

        await showMaterialModalBottomSheet(
          expand: false,
          context: context,
          useRootNavigator: true,
          builder: (context, controller) => DeliveryOptionsPanel(
            onPush: (deliveryType) {
              HapticFeedback.selectionClick();

              selected = true;

              Navigator.of(context).pop();

              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
                    position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(animation),
                    child: DeliveryNavigator(
                      deliveryType: deliveryType,
                      pickUpAddress: pickUpAddress,
                      userAddresses: userAddresses,
                      onClose: () async {
                        HapticFeedback.selectionClick();

                        await onClose?.call();
                        userAddressesRepository.dispose();

                        Navigator.of(context).pop();

                        if (originalOverlayStyle != null)
                          SystemChrome.setSystemUIOverlayStyle(originalOverlayStyle);
                      },
                      onFinish: (id) async {
                        HapticFeedback.lightImpact();

                        await onFinish?.call(deliveryType.items.first.id, id);
                        userAddressesRepository.dispose();

                        Navigator.of(context).pop();

                        if (originalOverlayStyle != null)
                          SystemChrome.setSystemUIOverlayStyle(originalOverlayStyle);
                      },
                    ),
                  ),
                ),
              );
            },
            options: types,
          ),
        );
      }

      if (!selected) onClose?.call();

      selected = false;
    }
  }

  @override
  void dispose() {
    widget.currentTab.removeListener(tabListener);

    widget.currentTab.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async =>
            !await navigatorKeys[widget.currentTab.value]?.currentState?.maybePop(),
        child: Stack(
          children: <Widget>[
            TabView(
              BottomTab.home,
              widget.currentTab,
              onTabRefresh: onTabRefresh,
              pushPageOnTop: pushPageOnTop,
              openDeliveryTypesSelector: openDeliveryTypesSelector,
            ),
            TabView(
              BottomTab.catalog,
              widget.currentTab,
              pushPageOnTop: pushPageOnTop,
              onTabRefresh: onTabRefresh,
              openDeliveryTypesSelector: openDeliveryTypesSelector,
            ),
            TabView(
              BottomTab.cart,
              widget.currentTab,
              onTabRefresh: onTabRefresh,
              pushPageOnTop: pushPageOnTop,
              openDeliveryTypesSelector: openDeliveryTypesSelector,
            ),
            TabView(
              BottomTab.profile,
              widget.currentTab,
              onTabRefresh: onTabRefresh,
              pushPageOnTop: pushPageOnTop,
              openDeliveryTypesSelector: openDeliveryTypesSelector,
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: CollectWidgetsData(
                widgets: [bottomNavWidgetData],
                sizesProvider: sizesProvider,
                child: SizedBox(
                  key: bottomNavWidgetData.key,
                  child: BottomNavigation(
                    widget.currentTab,
                    () => {
                      BaseRepository.isAuthorized().then((isAuthorized) {
                        return isAuthorized
                            ? Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      SlideTransition(
                                          position: Tween(begin: Offset(0, 1), end: Offset.zero)
                                              .animate(animation),
                                          child:
                                              ChangeNotifierProvider<SizeRepository>(create: (_) {
                                            return SizeRepository();
                                          }, builder: (context, _) {
                                            return MarketplaceNavigator(
                                              onClose: () => Navigator.of(context).pop(),
                                            );
                                          })),
                                ),
                              )
                            : showCupertinoModalBottomSheet(
                                backgroundColor: Colors.white,
                                expand: false,
                                context: context,
                                useRootNavigator: true,
                                builder: (context, controller) => AuthorizationSheet());
                      })
                    },
                    onTabRefresh,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
