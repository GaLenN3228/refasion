import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/cart/pages/cart_page.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/product/product.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';
import 'package:refashioned_app/screens/seller/pages/seller_page.dart';

class CartNavigatorRoutes {
  static const String cart = '/';
  static const String product = '/product';
  static const String seller = '/seller';
  static const String products = '/products';
  static const String favourites = '/favourites';
}

class CartNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    switch (previousRoute?.settings?.name) {
      case CartNavigatorRoutes.cart:
      case CartNavigatorRoutes.seller:
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
      case CartNavigatorRoutes.cart:
      case CartNavigatorRoutes.seller:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;

      default:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
    }
    super.didPush(route, previousRoute);
  }
}

class CartNavigator extends StatefulWidget {
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_CartNavigatorState>()
      : context.findAncestorStateOfType<_CartNavigatorState>();

  final GlobalKey<NavigatorState> navigatorKey;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function() onFinish,
    Future<bool> Function(String, String) onSelect,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  final Function(BottomTab) changeTabTo;
  final Function(PickPoint) openPickUpAddressMap;
  final Function(Seller, Function()) onSellerReviewsPush;

  final Function(Order, Function()) onCheckoutPush;

  const CartNavigator({
    Key key,
    this.navigatorKey,
    this.changeTabTo,
    this.openDeliveryTypesSelector,
    this.openPickUpAddressMap,
    @required this.onCheckoutPush,
    @required this.onSellerReviewsPush,
  }) : super(key: key);

  void pushFavourites(BuildContext context) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => CartNavigator.of(context)._routeBuilder(
              context,
              CartNavigatorRoutes.favourites,
            ),
            settings: RouteSettings(
              name: CartNavigatorRoutes.favourites,
            ),
          ),
        )
        .then((value) => topPanelController.needShow = true);
  }

  void pushProducts(BuildContext context, SearchResult searchResult) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => CartNavigator.of(context)._routeBuilder(
              context,
              CartNavigatorRoutes.products,
              searchResult: searchResult,
            ),
            settings: RouteSettings(
              name: CartNavigatorRoutes.products,
            ),
          ),
        )
        .then((value) => topPanelController.needShow = true);
  }

  @override
  _CartNavigatorState createState() {
    return _CartNavigatorState();
  }
}

class _CartNavigatorState extends State<CartNavigator> {
  Seller seller;
  int rating;

  Widget _routeBuilder(
    BuildContext context,
    String route, {
    Product product,
    Category category,
    String parameters,
    String productTitle,
    SearchResult searchResult,
  }) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    switch (route) {
      case CartNavigatorRoutes.cart:
        topPanelController.needShowBack = true;
        topPanelController.needShow = false;
        return CartPage(
          openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
          onCatalogPush: () => widget.changeTabTo(BottomTab.catalog),
          onCheckoutPush: widget.onCheckoutPush,
          onProductPush: (product) {
            return Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                  context,
                  CartNavigatorRoutes.product,
                  product: product,
                ),
                settings: RouteSettings(
                  name: CartNavigatorRoutes.product,
                ),
              ),
            );
          },
        );

      case CartNavigatorRoutes.product:
        topPanelController.needShow = false;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(
          create: (_) => AddRemoveFavouriteRepository(),
          builder: (context, _) => ProductPage(
            product: product,
            onCartPush: () => widget.changeTabTo(BottomTab.cart),
            openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
            onCheckoutPush: widget.onCheckoutPush,
            onProductPush: (product) {
              return Navigator.of(context)
                  .push(
                    CupertinoPageRoute(
                      builder: (context) => _routeBuilder(
                        context,
                        CartNavigatorRoutes.product,
                        product: product,
                      ),
                      settings: RouteSettings(
                        name: CartNavigatorRoutes.product,
                      ),
                    ),
                  )
                  .then((value) => topPanelController.needShow = false);
            },
            onSellerPush: (newSeller) {
              seller = newSeller;

              Navigator.of(context).pushNamed(CartNavigatorRoutes.seller);
            },
            onSubCategoryClick: (parameters, title) {
              return Navigator.of(context)
                  .push(
                    CupertinoPageRoute(
                      builder: (context) => _routeBuilder(
                        context,
                        CartNavigatorRoutes.products,
                        product: product,
                        category: category,
                        parameters: parameters,
                        productTitle: title,
                      ),
                      settings: RouteSettings(
                        name: CartNavigatorRoutes.products,
                      ),
                    ),
                  )
                  .then((value) => topPanelController.needShow = false);
            },
            onPickupAddressPush: widget.openPickUpAddressMap?.call,
          ),
        );

      case CartNavigatorRoutes.seller:
        topPanelController.needShow = false;
        topPanelController.needShowBack = false;
        return SellerPage(
          seller: seller,
          onSellerReviewsPush: (Function() callback) => widget.onSellerReviewsPush?.call(seller, callback),
          onProductPush: (product) => Navigator.of(context)
              .push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    CartNavigatorRoutes.product,
                    product: product,
                    category: category,
                  ),
                  settings: RouteSettings(
                    name: CartNavigatorRoutes.product,
                  ),
                ),
              )
              .then((value) => topPanelController.needShow = false),
        );

      case CartNavigatorRoutes.products:
        topPanelController.needShow = true;
        topPanelController.needShowBack = true;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductsPage(
            parameters: parameters,
            searchResult: searchResult,
            topCategory: category,
            title: productTitle,
            onPush: (product, {callback}) {
              return Navigator.of(context)
                  .push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    CartNavigatorRoutes.product,
                    product: product,
                    category: category,
                  ),
                  settings: RouteSettings(
                    name: CartNavigatorRoutes.product,
                  ),
                ),
              )
                  .then(
                (flag) {
                  topPanelController.needShow = true;
                  callback();
                },
              );
            },
          );
        });

      case CartNavigatorRoutes.favourites:
        topPanelController.needShow = false;
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<FavouritesProductsRepository>(
                  create: (_) => FavouritesProductsRepository()..getFavouritesProducts()),
              ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) => AddRemoveFavouriteRepository())
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
                            CartNavigatorRoutes.product,
                            product: product,
                            category: category,
                          ),
                          settings: RouteSettings(
                            name: CartNavigatorRoutes.product,
                          ),
                        ),
                      )
                      .then((value) => topPanelController.needShow = false);
                },
              );
            });

      default:
        return CupertinoPageScaffold(
          backgroundColor: Colors.white,
          child: Center(
            child: Text(
              "Default",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Navigator(
        initialRoute: CartNavigatorRoutes.cart,
        observers: [CartNavigatorObserver()],
        key: widget.navigatorKey,
        onGenerateInitialRoutes: (navigatorState, initialRoute) => [
          CupertinoPageRoute(
            builder: (context) => _routeBuilder(
              context,
              initialRoute,
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
          ),
          settings: routeSettings,
        ),
      );
}
