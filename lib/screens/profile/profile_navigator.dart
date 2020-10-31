import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/authorization.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/orders.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/authorization/name_page.dart';
import 'package:refashioned_app/screens/checkout/pages/checkout_page.dart';
import 'package:refashioned_app/screens/checkout/pages/order_created_page.dart';
import 'package:refashioned_app/screens/checkout/pages/payment_failed.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/components/webview_page.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';
import 'package:refashioned_app/screens/product/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';
import 'package:refashioned_app/screens/profile/loginned_profile.dart';
import 'package:refashioned_app/screens/profile/map_page.dart';
import 'package:refashioned_app/screens/profile/pages/my_addresses.dart';
import 'package:refashioned_app/screens/profile/profile.dart';
import 'package:refashioned_app/screens/profile/settings.dart';
import 'package:refashioned_app/screens/profile/user_profile.dart';
import 'package:refashioned_app/screens/seller/pages/seller_page.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProfileNavigatorRoutes {
  static const String root = '/';
  static const String myAddresses = '/my_addresses';
  static const String settings = '/settings';
  static const String doc = '/doc';
  static const String products = '/products';
  static const String product = '/product';
  static const String seller = '/seller';
  static const String favourites = '/favourites';
  static const String checkout = '/checkout';
  static const String orderCreated = '/order_created';
  static const String paymentFailed = '/payment_failed';
  static const String userProfile = '/user_profile';
  static const String userName = '/user_name';
}

class ProfileNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    switch (previousRoute?.settings?.name) {
      case ProfileNavigatorRoutes.root:
      case ProfileNavigatorRoutes.seller:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;

      default:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
    }

    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    switch (route?.settings?.name) {
      case ProfileNavigatorRoutes.seller:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;

      default:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
    }
    super.didPush(route, previousRoute);
  }
}

class ProfileNavigator extends StatefulWidget {
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_ProfileNavigatorState>()
      : context.findAncestorStateOfType<_ProfileNavigatorState>();

  final Function(BottomTab) changeTabTo;
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(Widget) pushPageOnTop;
  final Function(PickPoint) openPickUpAddressMap;

  final Function(Order, Function()) onCheckoutPush;
  final Function(Seller, Function()) onSellerReviewsPush;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function() onFinish,
    Future<bool> Function(String, String) onSelect,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  const ProfileNavigator({
    this.navigatorKey,
    this.changeTabTo,
    this.pushPageOnTop,
    this.openPickUpAddressMap,
    this.openDeliveryTypesSelector,
    @required this.onCheckoutPush,
    @required this.onSellerReviewsPush,
  });

  void pushFavourites(BuildContext context, bool needShowTopBar) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => ProfileNavigator.of(context)._routeBuilder(
              context,
              ProfileNavigatorRoutes.favourites,
            ),
            settings: RouteSettings(
              name: ProfileNavigatorRoutes.favourites,
            ),
          ),
        )
        .then((value) => topPanelController.needShow = needShowTopBar);
  }

  void pushProducts(BuildContext context, SearchResult searchResult) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
      CupertinoPageRoute(
        builder: (context) => ProfileNavigator.of(context)._routeBuilder(
          context,
          ProfileNavigatorRoutes.products,
          searchResult: searchResult,
        ),
        settings: RouteSettings(
          name: ProfileNavigatorRoutes.products,
        ),
      ),
    )
        .then((value) {
      topPanelController.needShow = true;
      topPanelController.needShowBack = false;
    });
  }

  @override
  _ProfileNavigatorState createState() {
    return _ProfileNavigatorState();
  }
}

class _ProfileNavigatorState extends State<ProfileNavigator> {
  CreateOrderRepository createOrderRepository;

  Order order;
  int totalPrice;

  String docUrl;
  String docTitle;

  Seller seller;
  int rating;

  @override
  initState() {
    createOrderRepository = CreateOrderRepository();

    super.initState();
  }

  @override
  dispose() {
    createOrderRepository.dispose();

    super.dispose();
  }

  Widget _routeBuilder(BuildContext context, String route,
      {bool isAuthorized,
      Category category,
      Product product,
      String parameters,
      String productTitle,
      SearchResult searchResult}) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    switch (route) {
      case ProfileNavigatorRoutes.root:
        topPanelController.needShowBack = true;
        topPanelController.needShow = false;
        if (isAuthorized)
          Future.delayed(Duration.zero, () {
            Provider.of<ProfileProductsRepository>(context, listen: false).getProducts();
          });
        return isAuthorized
            ? AuthorizedProfilePage(
                onProductPush: (product, {callback}) => Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      ProfileNavigatorRoutes.product,
                      product: product,
                    ),
                    settings: RouteSettings(
                      name: ProfileNavigatorRoutes.product,
                    ),
                  ),
                ),
                onFavClick: () {
                  widget.pushFavourites(context, false);
                },
                onSettingsClick: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => _routeBuilder(
                        context,
                        ProfileNavigatorRoutes.settings,
                        isAuthorized: isAuthorized,
                      ),
                      settings: RouteSettings(
                        name: ProfileNavigatorRoutes.settings,
                      ),
                    ),
                  );
                },
                onUserProfileClick: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => _routeBuilder(
                        context,
                        ProfileNavigatorRoutes.userProfile,
                      ),
                      settings: RouteSettings(
                        name: ProfileNavigatorRoutes.userProfile,
                      ),
                    ),
                  );
                },
                onMyAddressesPush: () => Navigator.of(context).pushNamed(
                  ProfileNavigatorRoutes.myAddresses,
                ),
              )
            : ProfilePage(
                onSettingsClick: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => _routeBuilder(
                        context,
                        ProfileNavigatorRoutes.settings,
                        isAuthorized: isAuthorized,
                      ),
                      settings: RouteSettings(
                        name: ProfileNavigatorRoutes.settings,
                      ),
                    ),
                  );
                },
                onMapPageClick: () {
                  widget.pushPageOnTop(MapPage());
                },
              );

      case ProfileNavigatorRoutes.myAddresses:
        return MyAddressesPage();

      case ProfileNavigatorRoutes.settings:
        return isAuthorized
            ? SettingForAuthUser(
                onMapPageClick: () {
                  widget.pushPageOnTop(MapPage());
                },
                onDocPush: (String url, String title) {
                  docUrl = url;
                  docTitle = title;

                  Navigator.of(context).pushNamed(ProfileNavigatorRoutes.doc);
                },
              )
            : SettingPage(
                onDocPush: (String url, String title) {
                  docUrl = url;
                  docTitle = title;

                  Navigator.of(context).pushNamed(ProfileNavigatorRoutes.doc);
                },
              );

      case ProfileNavigatorRoutes.userProfile:
        return UserProfile(
          onUserNamePush: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                  context,
                  ProfileNavigatorRoutes.userName,
                ),
                settings: RouteSettings(
                  name: ProfileNavigatorRoutes.userName,
                ),
              ),
            );
          },
          onMapPageClick: () {
            widget.pushPageOnTop(MapPage());
          },
          onDocPush: (String url, String title) {
            docUrl = url;
            docTitle = title;

            Navigator.of(context).pushNamed(ProfileNavigatorRoutes.doc);
          },
        );

      case ProfileNavigatorRoutes.userName:
        return KeyboardVisibilityProvider(
            child: NamePage(
          needDismiss: true,
          fullScreenMode: false,
        ));

      case ProfileNavigatorRoutes.doc:
        return WebViewPage(
          initialUrl: docUrl,
          title: docTitle,
        );

      case ProfileNavigatorRoutes.products:
        topPanelController.needShow = true;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductsPage(
            parameters: parameters,
            searchResult: searchResult,
            topCategory: category,
            title: productTitle,
            onPush: (product, {callback}) => Navigator.of(context)
                .push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                  context,
                  ProfileNavigatorRoutes.product,
                  product: product,
                  category: category,
                ),
                settings: RouteSettings(
                  name: ProfileNavigatorRoutes.product,
                ),
              ),
            )
                .then(
              (flag) {
                topPanelController.needShow = true;
                callback();
              },
            ),
          );
        });

      case ProfileNavigatorRoutes.product:
        topPanelController.needShow = false;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductPage(
            product: product,
            onCartPush: () => widget.changeTabTo(BottomTab.cart),
            onPickupAddressPush: widget.openPickUpAddressMap?.call,
            onProductPush: (product) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      ProfileNavigatorRoutes.product,
                      product: product,
                      category: category,
                    ),
                    settings: RouteSettings(
                      name: ProfileNavigatorRoutes.product,
                    ),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            onSellerPush: (newSeller) {
              seller = newSeller;

              Navigator.of(context).pushNamed(ProfileNavigatorRoutes.seller);
            },
            onSubCategoryClick: (parameters, title) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      ProfileNavigatorRoutes.products,
                      product: product,
                      category: category,
                      parameters: parameters,
                      productTitle: title,
                    ),
                    settings: RouteSettings(
                      name: ProfileNavigatorRoutes.products,
                    ),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
            onCheckoutPush: widget.onCheckoutPush,
          );
        });

      case ProfileNavigatorRoutes.seller:
        topPanelController.needShow = false;
        topPanelController.needShowBack = false;
        return SellerPage(
          seller: seller,
          onSellerReviewsPush: (Function() callback) =>
              widget.onSellerReviewsPush?.call(seller, callback),
          onProductPush: (product) => Navigator.of(context)
              .push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    ProfileNavigatorRoutes.product,
                    product: product,
                    category: category,
                  ),
                  settings: RouteSettings(
                    name: ProfileNavigatorRoutes.product,
                  ),
                ),
              )
              .then((value) => topPanelController.needShow = false),
        );

      case ProfileNavigatorRoutes.favourites:
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<FavouritesProductsRepository>(
                create: (_) => FavouritesProductsRepository()..getFavouritesProducts()),
            ChangeNotifierProvider<AddRemoveFavouriteRepository>(
                create: (_) => AddRemoveFavouriteRepository())
          ],
          builder: (context, _) {
            return FavouritesPage(
              onCatalogPush: () => widget.changeTabTo(BottomTab.catalog),
              onPush: (product) {
                Navigator.of(context)
                    .push(
                      CupertinoPageRoute(
                        builder: (context) => _routeBuilder(
                          context,
                          ProfileNavigatorRoutes.product,
                          product: product,
                          category: category,
                        ),
                        settings: RouteSettings(
                          name: ProfileNavigatorRoutes.product,
                        ),
                      ),
                    )
                    .then((value) => topPanelController.needShow = false);
              },
            );
          },
        );

      case ProfileNavigatorRoutes.checkout:
        return CheckoutPage(
          order: order,
          onPush: (newTotalPrice, {bool success}) async {
            totalPrice = newTotalPrice;

            await Navigator.of(context).pushReplacementNamed(
              success ?? false
                  ? ProfileNavigatorRoutes.orderCreated
                  : ProfileNavigatorRoutes.paymentFailed,
            );
          },
        );

      case ProfileNavigatorRoutes.orderCreated:
        return OrderCreatedPage(
          totalPrice: totalPrice,
          onUserOrderPush: () => widget.changeTabTo(
            BottomTab.profile,
          ),
        );

      case ProfileNavigatorRoutes.paymentFailed:
        return PaymentFailedPage(
          totalPrice: totalPrice,
        );

      default:
        return CupertinoPageScaffold(
          child: Center(
            child: Text(
              "Неизвестный маршрут: " + route.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CodeAuthorizationRepository, LogoutRepository>(
        builder: (context, codeAuthorization, logoutRepository, child) {
      if (codeAuthorization.isLoading || logoutRepository.isLoading)
        return Center(
            child: SizedBox(
          height: 32.0,
          width: 32.0,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: accentColor,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ));
      return FutureBuilder<bool>(
        future: BaseRepository.isAuthorized(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return Navigator(
              key: widget.navigatorKey,
              initialRoute: ProfileNavigatorRoutes.root,
              observers: [
                ProfileNavigatorObserver(),
              ],
              onGenerateInitialRoutes: (navigatorState, initialRoute) => [
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    initialRoute,
                    isAuthorized: snapshot.data,
                  ),
                  settings: RouteSettings(
                    name: initialRoute,
                  ),
                ),
              ],
              onGenerateRoute: (routeSettings) => CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                  context,
                  routeSettings.name,
                  isAuthorized: snapshot.data,
                ),
                settings: routeSettings,
              ),
            );
          }
          return SizedBox();
        },
      );
    });
  }
}
