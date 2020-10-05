import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/orders.dart';
import 'package:refashioned_app/screens/cart/pages/checkout_page.dart';
import 'package:refashioned_app/screens/cart/pages/order_created_page.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';
import 'package:refashioned_app/screens/product/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';

import 'home.dart';

class HomeNavigatorRoutes {
  static const String root = '/';
  static const String products = '/products';
  static const String product = '/product';
  static const String favourites = '/favourites';
  static const String checkout = '/checkout';
  static const String orderCreated = '/order_created';
}

class HomeNavigator extends StatefulWidget {
  final Function(BottomTab) changeTabTo;
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(PickPoint) openPickUpAddressMap;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function(String, String) onFinish,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  _HomeNavigatorState _homeNavigatorState;

  HomeNavigator({this.navigatorKey, this.changeTabTo, this.openPickUpAddressMap, this.openDeliveryTypesSelector});

  void pushFavourites(BuildContext context) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => _homeNavigatorState._routeBuilder(context, HomeNavigatorRoutes.favourites),
          ),
        )
        .then((value) => topPanelController.needShow = true);
  }

  void pushProducts(BuildContext context, SearchResult searchResult) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
      CupertinoPageRoute(
        builder: (context) =>
            _homeNavigatorState._routeBuilder(context, HomeNavigatorRoutes.products, searchResult: searchResult),
      ),
    )
        .then((value) {
      topPanelController.needShow = true;
      topPanelController.needShowBack = false;
    });
  }

  @override
  _HomeNavigatorState createState() {
    _homeNavigatorState = _HomeNavigatorState();
    return _homeNavigatorState;
  }
}

class _HomeNavigatorState extends State<HomeNavigator> {
  CreateOrderRepository createOrderRepository;

  Order order;
  int totalPrice;

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
      {Category category,
      Product product,
      Seller seller,
      String parameters,
      Order order,
      String productTitle,
      SearchResult searchResult,
      String collectionUrl}) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    switch (route) {
      case HomeNavigatorRoutes.root:
        topPanelController.needShowBack = false;
        return HomePage(
          pushProduct: (product) {
            Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(context, HomeNavigatorRoutes.product, product: product),
                  ),
                )
                .then((value) => topPanelController.needShow = true);
          },
          pushCollection: (url, title) {
            Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) =>
                        _routeBuilder(context, HomeNavigatorRoutes.products, collectionUrl: url, productTitle: title),
                    settings: RouteSettings(name: HomeNavigatorRoutes.products),
                  ),
                )
                .then((value) => {topPanelController.needShow = true, topPanelController.needShowBack = false});
          },
        );

      case HomeNavigatorRoutes.products:
        topPanelController.needShow = true;
        topPanelController.needShowBack = true;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductsPage(
            collectionUrl: collectionUrl,
            parameters: parameters,
            searchResult: searchResult,
            topCategory: category,
            title: productTitle,
            onPush: (product, {callback}) => Navigator.of(context)
                .push(
              CupertinoPageRoute(
                builder: (context) =>
                    _routeBuilder(context, HomeNavigatorRoutes.product, product: product, category: category),
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

      case HomeNavigatorRoutes.product:
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
                    builder: (context) =>
                        _routeBuilder(context, HomeNavigatorRoutes.product, product: product, category: category),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            onSubCategoryClick: (parameters, title) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(context, HomeNavigatorRoutes.products,
                        product: product, category: category, parameters: parameters, productTitle: title),
                    settings: RouteSettings(name: HomeNavigatorRoutes.products),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
            onCheckoutPush: (orderParameters) async {
              await createOrderRepository.update(orderParameters);

              order = createOrderRepository.response?.content;
              if (order != null)
                return Navigator.of(context).push(
                  MaterialWithModalsPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      HomeNavigatorRoutes.checkout,
                    ),
                    settings: RouteSettings(
                      name: HomeNavigatorRoutes.checkout,
                    ),
                  ),
                );
            },
          );
        });

      case HomeNavigatorRoutes.favourites:
        topPanelController.needShow = false;
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<FavouritesProductsRepository>(
                  create: (_) => FavouritesProductsRepository()..getFavouritesProducts()),
              ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) => AddRemoveFavouriteRepository())
            ],
            builder: (context, _) {
              return FavouritesPage(onPush: (product) {
                Navigator.of(context)
                    .push(
                      CupertinoPageRoute(
                        builder: (context) =>
                            _routeBuilder(context, HomeNavigatorRoutes.product, product: product, category: category),
                      ),
                    )
                    .then((value) => topPanelController.needShow = false);
              });
            });

      case HomeNavigatorRoutes.checkout:
        return CheckoutPage(
          order: order,
          onOrderCreatedPush: (newTotalPrice) async {
            totalPrice = newTotalPrice;
            await Navigator.of(context).pushReplacementNamed(
              HomeNavigatorRoutes.orderCreated,
            );
          },
        );

      case HomeNavigatorRoutes.orderCreated:
        return OrderCreatedPage(
          totalPrice: totalPrice,
          onUserOrderPush: () => widget.changeTabTo(
            BottomTab.profile,
          ),
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
  Widget build(BuildContext context) => Navigator(
        key: widget.navigatorKey,
        initialRoute: HomeNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) => CupertinoPageRoute(
          builder: (context) => _routeBuilder(context, routeSettings.name),
        ),
      );
}
