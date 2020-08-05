import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  static const String product = '/product';
  static const String search = '/search';
}

class ShowTabBarNavigationObserver extends NavigatorObserver {
  final Function() hideTabBar;
  final Function() showTabBar;

  ShowTabBarNavigationObserver({this.showTabBar, this.hideTabBar});

  @override
  void didPop(Route route, Route previousRoute) {
    if (route.settings?.name == CatalogNavigatorRoutes.product) showTabBar();
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    if (route.settings?.name == CatalogNavigatorRoutes.product) hideTabBar();
    super.didPush(route, previousRoute);
  }
}

class CatalogNavigator extends StatelessWidget {
  CatalogNavigator({this.navigatorKey, this.hideTabBar, this.showTabBar});
  final GlobalKey<NavigatorState> navigatorKey;
  final Function() hideTabBar;
  final Function() showTabBar;

  _pushSearch(BuildContext context) => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) =>
              _routeBuilder(context, CatalogNavigatorRoutes.search),
          settings: RouteSettings(name: CatalogNavigatorRoutes.search),
        ),
      );

  Widget _routeBuilder(BuildContext context, String route,
      {Category category, List<Category> categories, Product product}) {
    switch (route) {
      case CatalogNavigatorRoutes.root:
        return CatalogRootPage(
          categories: categories,
          onSearch: () => _pushSearch(context),
          onPush: (category) {
            final newRoute = category.children.isNotEmpty
                ? CatalogNavigatorRoutes.categories
                : CatalogNavigatorRoutes.category;

            return Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) =>
                    _routeBuilder(context, newRoute, category: category),
                settings: RouteSettings(name: newRoute),
              ),
            );
          },
        );

      case CatalogNavigatorRoutes.categories:
        return CategoryPage(
          onSearch: () => _pushSearch(context),
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
                settings: RouteSettings(name: newRoute),
              ),
            );
          },
        );

      case CatalogNavigatorRoutes.category:
        return CategoryPage(
          onSearch: () => _pushSearch(context),
          topCategory: category,
          level: CategoryLevel.category,
          onPush: (_) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CatalogNavigatorRoutes.products,
                  category: category),
              settings: RouteSettings(name: CatalogNavigatorRoutes.products),
            ),
          ),
        );

      case CatalogNavigatorRoutes.products:
        return ProductsPage(
          onSearch: () => _pushSearch(context),
          id: category.id,
          categoryName: category.name,
          categories: category.children,
          onPush: (product) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CatalogNavigatorRoutes.product,
                  product: product),
              settings: RouteSettings(name: CatalogNavigatorRoutes.product),
            ),
          ),
        );

      case CatalogNavigatorRoutes.product:
        return ProductPage(
          id: product.id,
          onPush: (product) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CatalogNavigatorRoutes.product,
                  product: product),
              settings: RouteSettings(name: CatalogNavigatorRoutes.product),
            ),
          ),
        );

      case CatalogNavigatorRoutes.search:
        return SearchPage();

      default:
        return Center(
          child: Text("Default"),
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
      observers: [
        ShowTabBarNavigationObserver(
            hideTabBar: hideTabBar, showTabBar: showTabBar)
      ],
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
