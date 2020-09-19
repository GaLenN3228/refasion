import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/cart.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/order/order_item.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/repositories/orders.dart';
import 'package:refashioned_app/screens/cart/pages/cart_page.dart';
import 'package:refashioned_app/screens/cart/pages/checkout_page.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/product/product.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';

class CartNavigatorRoutes {
  static const String cart = '/';
  static const String product = '/product';
  static const String seller = '/seller';
  static const String checkout = '/checkout';
  static const String products = '/products';
  static const String favourites = '/favourites';
}

class CartNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    PickPoint pickUpAddress,
    Function() onClose,
    Function(String, String) onFinish,
  }) openDeliveryTypesSelector;

  _CartNavigatorState _cartNavigatorState;

  final Function(BottomTab) changeTabTo;

  CartNavigator({Key key, this.navigatorKey, this.changeTabTo, this.openDeliveryTypesSelector})
      : super(key: key);

  void pushFavourites(BuildContext context) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) =>
                _cartNavigatorState._routeBuilder(context, CartNavigatorRoutes.favourites),
          ),
        )
        .then((value) => topPanelController.needShow = true);
  }

  void pushProducts(BuildContext context, SearchResult searchResult) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => _cartNavigatorState
                ._routeBuilder(context, CartNavigatorRoutes.products, searchResult: searchResult),
          ),
        )
        .then((value) => topPanelController.needShow = true);
  }

  @override
  _CartNavigatorState createState() {
    _cartNavigatorState = _CartNavigatorState();
    return _cartNavigatorState;
  }
}

class _CartNavigatorState extends State<CartNavigator> {
  CreateOrderRepository createOrderRepository;

  GetOrderRepository getOrderRepository;

  @override
  initState() {
    createOrderRepository = CreateOrderRepository();

    getOrderRepository = GetOrderRepository();

    super.initState();
  }

  @override
  dispose() {
    createOrderRepository.dispose();

    getOrderRepository.dispose();

    super.dispose();
  }

  Widget _routeBuilder(BuildContext context, String route,
      {Cart cart,
      Order order,
      Product product,
      Category category,
      String parameters,
      String productTitle,
      SearchResult searchResult}) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    switch (route) {
      case CartNavigatorRoutes.cart:
        topPanelController.needShowBack = true;
        topPanelController.needShow = false;
        return CartPage(
          openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
          onCatalogPush: () => widget.changeTabTo(BottomTab.catalog),
          onCheckoutPush: (order) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  _routeBuilder(context, CartNavigatorRoutes.checkout, cart: cart, order: order),
              settings: RouteSettings(
                name: CartNavigatorRoutes.checkout,
              ),
            ),
          ),
          onProductPush: (product) => Navigator.of(context).push(
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
          ),
        );

      case CartNavigatorRoutes.product:
        topPanelController.needShow = false;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(
          create: (_) => AddRemoveFavouriteRepository(),
          builder: (context, _) => ProductPage(
            product: product,
            onCartPush: () => widget.changeTabTo(BottomTab.cart),
            openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
            onCheckoutPush: (deliveryCompanyId, deliveryObjectId) async {
              final parameters = jsonEncode([
                OrderItem(
                  deliveryCompany: deliveryCompanyId,
                  deliveryObjectId: deliveryObjectId,
                  products: [product.id],
                ),
              ]);

              await createOrderRepository.update(parameters);

              final orderId = createOrderRepository.response?.content?.id;

              await getOrderRepository.update(orderId);

              return Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    CartNavigatorRoutes.checkout,
                  ),
                ),
              );
            },
            onProductPush: (product) => Navigator.of(context)
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
                .then((value) => topPanelController.needShow = false),
            onSubCategoryClick: (parameters, title) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(context, CartNavigatorRoutes.products,
                        product: product,
                        category: category,
                        parameters: parameters,
                        productTitle: title),
                    settings: RouteSettings(name: CartNavigatorRoutes.products),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
          ),
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
            onPush: (product, {callback}) => Navigator.of(context)
                .push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(context, CartNavigatorRoutes.product,
                    product: product, category: category),
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

      case CartNavigatorRoutes.favourites:
        topPanelController.needShow = false;
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<FavouritesProductsRepository>(
                  create: (_) => FavouritesProductsRepository()..getFavouritesProducts()),
              ChangeNotifierProvider<AddRemoveFavouriteRepository>(
                  create: (_) => AddRemoveFavouriteRepository())
            ],
            builder: (context, _) {
              return FavouritesPage(onPush: (product) {
                Navigator.of(context)
                    .push(
                      CupertinoPageRoute(
                        builder: (context) => _routeBuilder(context, CartNavigatorRoutes.product,
                            product: product, category: category),
                      ),
                    )
                    .then((value) => topPanelController.needShow = false);
              });
            });

      case CartNavigatorRoutes.checkout:
        return CheckoutPage(
          order: order,
          cart: cart,
        );

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
        key: widget.navigatorKey,
        onGenerateRoute: (routeSettings) => CupertinoPageRoute(
          builder: (context) => _routeBuilder(context, routeSettings.name),
          settings: routeSettings,
        ),
      );
}
