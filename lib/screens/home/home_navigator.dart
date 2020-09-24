import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/order/order_item.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/orders.dart';
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
}

class HomeNavigator extends StatelessWidget {
  final Function(BottomTab) changeTabTo;
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(PickPoint) openPickUpAddressMap;

  CreateOrderRepository createOrderRepository;

  GetOrderRepository getOrderRepository;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function(String, String) onFinish,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  HomeNavigator(
      {this.navigatorKey,
      this.changeTabTo,
      this.openPickUpAddressMap,
      this.openDeliveryTypesSelector});

  void pushFavourites(BuildContext context) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => _routeBuilder(context, HomeNavigatorRoutes.favourites),
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
            _routeBuilder(context, HomeNavigatorRoutes.products, searchResult: searchResult),
      ),
    )
        .then((value) {
      topPanelController.needShow = true;
      topPanelController.needShowBack = false;
    });
  }

  Widget _routeBuilder(BuildContext context, String route,
      {Category category,
      Product product,
      Seller seller,
      String parameters,
      Order order,
      String productTitle,
      SearchResult searchResult}) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    switch (route) {
      case HomeNavigatorRoutes.root:
        topPanelController.needShowBack = false;
        return HomePage();

      case HomeNavigatorRoutes.products:
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
                builder: (context) => _routeBuilder(context, HomeNavigatorRoutes.product,
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

      case HomeNavigatorRoutes.product:
        topPanelController.needShow = false;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductPage(
            product: product,
            onCartPush: () => changeTabTo(BottomTab.cart),
            onPickupAddressPush: openPickUpAddressMap?.call,
            onProductPush: (product) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(context, HomeNavigatorRoutes.product,
                        product: product, category: category),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            onSubCategoryClick: (parameters, title) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(context, HomeNavigatorRoutes.products,
                        product: product,
                        category: category,
                        parameters: parameters,
                        productTitle: title),
                    settings: RouteSettings(name: HomeNavigatorRoutes.products),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            openDeliveryTypesSelector: openDeliveryTypesSelector,
            onCheckoutPush: (orderParameters) async {
              await createOrderRepository.update(orderParameters);

              final orderId = createOrderRepository.response?.content?.id;

              await getOrderRepository.update(orderId);

              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    HomeNavigatorRoutes.checkout,
                    order: createOrderRepository.response?.content,
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
              ChangeNotifierProvider<AddRemoveFavouriteRepository>(
                  create: (_) => AddRemoveFavouriteRepository())
            ],
            builder: (context, _) {
              return FavouritesPage(onPush: (product) {
                Navigator.of(context)
                    .push(
                      CupertinoPageRoute(
                        builder: (context) => _routeBuilder(context, HomeNavigatorRoutes.product,
                            product: product, category: category),
                      ),
                    )
                    .then((value) => topPanelController.needShow = false);
              });
            });

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
    createOrderRepository = CreateOrderRepository();

    getOrderRepository = GetOrderRepository();

    return Navigator(
      key: navigatorKey,
      initialRoute: HomeNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) => _routeBuilder(context, routeSettings.name),
        );
      },
    );
  }
}
