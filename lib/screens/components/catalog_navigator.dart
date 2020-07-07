import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/screens/catalog/pages/category_page.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/catalog/pages/products_page.dart';
import 'package:refashioned_app/screens/product/pages/product.dart';

class CatalogNavigatorRoutes {
  static const String root = '/';
  static const String categories = '/categories';
  static const String category = '/categories/category';
  static const String items = '/categories/category/items';
  static const String item = '/categories/category/items/item';
}

class ShowTabBarNavigationObserver extends NavigatorObserver {
  final Function() hideTabBar;
  final Function() showTabBar;

  ShowTabBarNavigationObserver({this.showTabBar, this.hideTabBar});

  @override
  void didPop(Route route, Route previousRoute) {
    if (route.settings?.name == CatalogNavigatorRoutes.item) showTabBar();
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    if (route.settings?.name == CatalogNavigatorRoutes.item) hideTabBar();
    super.didPush(route, previousRoute);
  }
}

class CatalogNavigator extends StatelessWidget {
  CatalogNavigator({this.navigatorKey, this.hideTabBar, this.showTabBar});
  final GlobalKey<NavigatorState> navigatorKey;
  final Function() hideTabBar;
  final Function() showTabBar;

  void _pushCategories(BuildContext context, Category category) =>
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _routeBuilder(
                context, category, CatalogNavigatorRoutes.categories)(context),
            settings: RouteSettings(name: CatalogNavigatorRoutes.categories)),
      );

  void _pushCategory(BuildContext context, Category category) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _routeBuilder(
                context, category, CatalogNavigatorRoutes.category)(context),
            settings: RouteSettings(name: CatalogNavigatorRoutes.category)),
      );

  void _pushItems(BuildContext context, Category category) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _routeBuilder(
                context, category, CatalogNavigatorRoutes.items)(context),
            settings: RouteSettings(name: CatalogNavigatorRoutes.items)),
      );

  void _pushItem(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _routeBuilder(
                context, null, CatalogNavigatorRoutes.item)(context),
            settings: RouteSettings(name: CatalogNavigatorRoutes.item)),
      );

  WidgetBuilder _routeBuilder(
      BuildContext context, Category category, String route) {
    switch (route) {
      case CatalogNavigatorRoutes.root:
        return (context) => CategoryPage(
              canPop: false,
              category: category,
              level: CategoryLevel.root,
              onPush: (category) {
                if (category.children.isNotEmpty)
                  _pushCategories(context, category);
                else
                  _pushItems(context, category);
              },
            );

      case CatalogNavigatorRoutes.categories:
        return (context) => CategoryPage(
              canPop: true,
              onPop: () => Navigator.pop(context),
              category: category,
              level: CategoryLevel.categories,
              onPush: (category) {
                if (category.children.isNotEmpty)
                  _pushCategory(context, category);
                else
                  _pushItems(context, category);
              },
            );

      case CatalogNavigatorRoutes.category:
        return (context) => CategoryPage(
              canPop: true,
              onPop: () => Navigator.pop(context),
              category: category,
              level: CategoryLevel.category,
              onPush: (category) => _pushItems(context, category),
            );

      case CatalogNavigatorRoutes.items:
        return (context) => ProductsPage(
              onPop: () => Navigator.pop(context),
              onPush: (product) => _pushItem(context),
            );

      case CatalogNavigatorRoutes.item:
        return (context) => ProductPage(
              onPop: () => Navigator.pop(context),
            );

      default:
        return (context) => Center(
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

    final selectedTopCategory =
        catalogRepository.catalogResponse.categories.first;

    return Navigator(
      key: navigatorKey,
      observers: [
        ShowTabBarNavigationObserver(
            hideTabBar: hideTabBar, showTabBar: showTabBar)
      ],
      initialRoute: CatalogNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => _routeBuilder(
              context, selectedTopCategory, routeSettings.name)(context),
        );
      },
    );
  }
}
