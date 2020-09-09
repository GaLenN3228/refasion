import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_wrapper_page.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/product_navigator.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';

class ScreenNavigatorRoutes {
  static const String catalog = '/catalog';
  static const String product = '/product';
  static const String fav = '/fav';
}

class ScreenNavigator extends StatelessWidget {
  GlobalKey<NavigatorState> catalogKey;
  GlobalKey<NavigatorState> productKey;
  GlobalKey<NavigatorState> screensKey;

  ProductNavigator _productNavigator;

  CatalogNavigator _catalogNavigator;

  Widget routeBuilder(BuildContext context, String route,
      {Category category,
      List<Category> categories,
      Product product,
      Seller seller,
      String parameters,
      String productTitle,
      SearchResult searchResult}) {
    switch (route) {
      case ScreenNavigatorRoutes.catalog:
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController())
            ],
            builder: (context, _) {
              return CatalogWrapperPage(
                catalogNavigator: _catalogNavigator,
                onFavClick: () {
                  return Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => routeBuilder(context, ScreenNavigatorRoutes.fav, product: product)));
                },
                navigatorKey: catalogKey,
                productKey: productKey,
                screenKey: screensKey,
              );
            });

      // case ScreenNavigatorRoutes.product:
      //   return ProductNavigator(
      //     product: product,
      //     productKey: productKey,
      //     screenKey: screensKey,
      //     pushPageOnTop: (id, title) {
      //       Navigator.of(context).pushAndRemoveUntil(
      //           CupertinoPageRoute(
      //               builder: (context) => _catalogNavigator.routeBuilder(
      //                   productKey.currentContext, CatalogNavigatorRoutes.products,
      //                   parameters: id, productTitle: title),
      //               settings: RouteSettings(name: CatalogNavigatorRoutes.products)),
      //           ModalRoute.withName(ModalRoute.of(productKey.currentContext).settings.name));
      //     },
      //   );

      case ScreenNavigatorRoutes.fav:
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<FavouritesProductsRepository>(
                  create: (_) => FavouritesProductsRepository()..getFavouritesProducts()),
              ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) => AddRemoveFavouriteRepository())
            ],
            builder: (context, _) {
              return FavouritesPage(
                onPush: (product) => Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) =>
                        routeBuilder(context, ScreenNavigatorRoutes.product, product: product, category: category),
                  ),
                ),
              );
            });

      default:
        return CupertinoPageScaffold(
          child: Center(
            child: Text(
              "Неизвестный маршрут9879: " + route.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    catalogKey = GlobalKey<NavigatorState>();
    productKey = GlobalKey<NavigatorState>();
    screensKey = GlobalKey<NavigatorState>();

    // _catalogNavigator = CatalogNavigator(
    //     navigatorKey: catalogKey,
    //     onPushPageOnTop: (product) {
    //       return Navigator.of(screensKey.currentContext).push(CupertinoPageRoute(
    //           builder: (context) =>
    //               routeBuilder(screensKey.currentContext, ScreenNavigatorRoutes.product, product: product)));
    //     });

    return Navigator(
      key: screensKey,
      initialRoute: ScreenNavigatorRoutes.catalog,
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) => routeBuilder(context, routeSettings.name),
        );
      },
    );
  }
}