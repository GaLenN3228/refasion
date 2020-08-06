import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_root_page.dart';
import 'package:refashioned_app/screens/catalog/pages/category_page.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/catalog/search/search_page.dart';
import 'package:refashioned_app/screens/product/pages/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';

class CatalogNavigatorRoutes {
  static const String root = '/';
  static const String categories = '/categories';
  static const String category = '/category';
  static const String products = '/products';
}

class CatalogNavigator extends StatelessWidget {
  CatalogNavigator({this.navigatorKey, this.onPushPageOnTop});
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(Widget) onPushPageOnTop;

  Widget _routeBuilder(BuildContext context, String route,
      {Category category, List<Category> categories, Product product}) {
    switch (route) {
      case CatalogNavigatorRoutes.root:
        return CatalogRootPage(
          categories: categories,
          onSearch: () => onPushPageOnTop(SearchPage()),
          onPush: (category) {
            final newRoute = category.children.isNotEmpty
                ? CatalogNavigatorRoutes.categories
                : CatalogNavigatorRoutes.category;

            return Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) =>
                    _routeBuilder(context, newRoute, category: category),
              ),
            );
          },
        );

      case CatalogNavigatorRoutes.categories:
        return CategoryPage(
          onSearch: () => onPushPageOnTop(SearchPage()),
          topCategory: category,
          level: CategoryLevel.categories,
          onPush: (category) {
            final newRoute = category.children.isNotEmpty
                ? CatalogNavigatorRoutes.category
                : CatalogNavigatorRoutes.products;

            return Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) =>
                    _routeBuilder(context, newRoute, category: category),
              ),
            );
          },
        );

      case CatalogNavigatorRoutes.category:
        return CategoryPage(
          onSearch: () => onPushPageOnTop(SearchPage()),
          topCategory: category,
          level: CategoryLevel.category,
          onPush: (_) => Navigator.of(context).push(
            MaterialWithModalsPageRoute(
              builder: (context) => _routeBuilder(
                  context, CatalogNavigatorRoutes.products,
                  category: category),
            ),
          ),
        );

      case CatalogNavigatorRoutes.products:
        return ProductsPage(
          onSearch: () => onPushPageOnTop(SearchPage()),
          topCategory: category,
          onPush: (product) => onPushPageOnTop(ProductPage(id: product.id)),
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

    if (catalogRepository.loadingFailed ||
        catalogRepository.catalogResponse.status.code != 200)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    return Navigator(
      key: navigatorKey,
      initialRoute: CatalogNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) => _routeBuilder(context, routeSettings.name,
              categories: catalogRepository.catalogResponse.categories),
        );
      },
    );
  }
}
