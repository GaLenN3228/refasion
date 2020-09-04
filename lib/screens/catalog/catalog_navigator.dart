import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_root_page.dart';
import 'package:refashioned_app/screens/catalog/pages/category_page.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/catalog/search/search_page.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';
import 'package:refashioned_app/screens/product/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';
import 'package:refashioned_app/screens/seller/seller_page.dart';

class CatalogNavigatorRoutes {
  static const String root = '/';
  static const String categories = '/categories';
  static const String category = '/category';
  static const String products = '/products';
  static const String product = '/product';
  static const String seller = '/seller';
  static const String favourites = '/favourites';
}

class CatalogNavigator extends StatelessWidget {
  CatalogNavigator({this.navigatorKey, this.onPushPageOnTop, this.productKey, this.updateTopBar});

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<NavigatorState> productKey;
  final Function(Product) onPushPageOnTop;

  final Function(bool) updateTopBar;

  Widget routeBuilder(BuildContext context, String route,
      {Category category,
      List<Category> categories,
      Product product,
      Seller seller,
      String parameters,
      String productTitle,
      SearchResult searchResult}) {
    switch (route) {
      case CatalogNavigatorRoutes.root:
        updateTopBar(false);
        return CatalogRootPage(
            categories: categories,
            onPush: (category) {
              final newRoute =
                  category.children.isNotEmpty ? CatalogNavigatorRoutes.categories : CatalogNavigatorRoutes.category;

              return Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => routeBuilder(context, newRoute, category: category),
                ),
              );
            },
            onFavouritesClick: () => Navigator.of(context).push(
                  MaterialWithModalsPageRoute(
                    builder: (context) => routeBuilder(context, CatalogNavigatorRoutes.favourites,
                        category: category, parameters: parameters),
                  ),
                ));

      case CatalogNavigatorRoutes.categories:
        updateTopBar(true);
        return CategoryPage(
            topCategory: category,
            level: CategoryLevel.categories,
            onPush: (category, {callback}) {
              final newRoute =
                  category.children.isNotEmpty ? CatalogNavigatorRoutes.category : CatalogNavigatorRoutes.products;

              return Navigator.of(context)
                  .push(
                    CupertinoPageRoute(
                      builder: (context) => routeBuilder(context, newRoute, category: category),
                      settings: RouteSettings(name: newRoute),
                    ),
                  )
                  .then((flag) => callback(category: category));
            },
            onFavouritesClick: () => Navigator.of(context).push(
                  MaterialWithModalsPageRoute(
                    builder: (context) => routeBuilder(context, CatalogNavigatorRoutes.favourites,
                        category: category, parameters: parameters),
                  ),
                ));

      case CatalogNavigatorRoutes.category:
        updateTopBar(true);
        return ChangeNotifierProvider<ProductsCountRepository>(create: (_) {
          return ProductsCountRepository()..getProductsCount("?p=" + category.id);
        }, builder: (context, _) {
          return CategoryPage(
              topCategory: category,
              level: CategoryLevel.category,
              onPush: (_, {callback}) => Navigator.of(context)
                      .push(
                    MaterialWithModalsPageRoute(
                      builder: (context) => routeBuilder(context, CatalogNavigatorRoutes.products, category: category),
                    ),
                  )
                      .then((flag) {
                    callback();
                  }),
              onFavouritesClick: () => Navigator.of(context).push(
                    MaterialWithModalsPageRoute(
                      builder: (context) => routeBuilder(context, CatalogNavigatorRoutes.favourites,
                          category: category, parameters: parameters),
                    ),
                  ));
        });

      case CatalogNavigatorRoutes.products:
        updateTopBar(true);
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductsPage(
              searchResult: searchResult,
              topCategory: category,
              title: productTitle,
              onPush: (product, {callback}) => onPushPageOnTop(product),
              onFavouritesClick: ({callback}) => Navigator.of(context)
                      .push(
                    MaterialWithModalsPageRoute(
                      builder: (context) => routeBuilder(context, CatalogNavigatorRoutes.favourites,
                          category: category, parameters: parameters),
                    ),
                  )
                      .then((flag) {
                    callback();
                  }));
        });

      case CatalogNavigatorRoutes.seller:
        return SellerPage(
          seller: seller,
          onProductPush: (product) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  routeBuilder(context, CatalogNavigatorRoutes.product, product: product, category: category),
            ),
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
  Widget build(BuildContext context) {
    final catalogRepository = context.watch<CatalogRepository>();

    if (catalogRepository.isLoading)
      return Center(
        child: Text(
          "Загрузка",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );

    if (catalogRepository.loadingFailed || catalogRepository.getStatusCode != 200)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    return Navigator(
      key: navigatorKey,
      initialRoute: CatalogNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) =>
              routeBuilder(context, routeSettings.name, categories: catalogRepository.response.content),
        );
      },
    );
  }
}
