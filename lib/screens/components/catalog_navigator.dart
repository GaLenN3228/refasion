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
  static const String category = '/categories/category';
  static const String products = '/categories/category/products';
  static const String product = '/categories/category/products/product';
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

  void _pushCategories(BuildContext context, Category category) =>
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _routeBuilder(
                CatalogNavigatorRoutes.categories,
                category: category)(context),
            settings: RouteSettings(name: CatalogNavigatorRoutes.categories)),
      );

  void _pushSearch(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                _routeBuilder(CatalogNavigatorRoutes.search)(context),
            settings: RouteSettings(name: CatalogNavigatorRoutes.search)),
      );

  void _pushCategory(BuildContext context, Category category, {Category secondLvlCategory}) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _routeBuilder(CatalogNavigatorRoutes.category,
                category: category, secondLvlCategory: secondLvlCategory)(context),
            settings: RouteSettings(name: CatalogNavigatorRoutes.category)),
      );

  void _pushProducts(BuildContext context, Category category, {Category secondLvlCategory, List<Category> lastCategories}) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _routeBuilder(CatalogNavigatorRoutes.products,
                category: category, secondLvlCategory: secondLvlCategory, lastCategories: lastCategories)(context),
            settings: RouteSettings(name: CatalogNavigatorRoutes.products)),
      );

  void _pushProduct(BuildContext context, Product product) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _routeBuilder(CatalogNavigatorRoutes.product,
                product: product)(context),
            settings: RouteSettings(name: CatalogNavigatorRoutes.product)),
      );

  //TODO refactor secondLvlCategory and lastCategories after the third lvl categories screen changes
  WidgetBuilder _routeBuilder(String route,
      {Category category, List<Category> categories, Product product, Category secondLvlCategory, List<Category> lastCategories}) {
    switch (route) {
      case CatalogNavigatorRoutes.root:
        return (context) => CatalogRootPage(
              categories: categories,
              onSearch: () => _pushSearch(context),
              onPush: (category) {
                if (category.children.isNotEmpty)
                  _pushCategories(context, category);
                else
                  _pushProducts(context, category, secondLvlCategory: category);
              },
            );

      case CatalogNavigatorRoutes.categories:
        return (context) => CategoryPage(
              canPop: true,
              onPop: () => Navigator.pop(context),
              onSearch: () => _pushSearch(context),
              category: category,
              level: CategoryLevel.categories,
              onPush: (category, {secondLvlCategory, lastCategories}) {
                if (category.children.isNotEmpty)
                  _pushCategory(context, category, secondLvlCategory: secondLvlCategory);
                else
                  _pushProducts(context, category, secondLvlCategory: secondLvlCategory);
              },
            );

      case CatalogNavigatorRoutes.category:
        return (context) => CategoryPage(
              canPop: true,
              onPop: () => Navigator.pop(context),
              onSearch: () => _pushSearch(context),
              category: category,
              level: CategoryLevel.category,
              onPush: (category, {secondLvlCategory, lastCategories}) => _pushProducts(context, category..reset()..selected = true, secondLvlCategory: secondLvlCategory, lastCategories: lastCategories),
            );

      case CatalogNavigatorRoutes.products:
        return (context) => ProductsPage(
            onPush: (product) => _pushProduct(context, product),
            onSearch: () => _pushSearch(context),
            id: category.id,
            categoryName: secondLvlCategory.name,
            categories: lastCategories);

      case CatalogNavigatorRoutes.product:
        return (context) => ProductPage(
              id: product.id,
              onPop: () => Navigator.pop(context),
            );

      case CatalogNavigatorRoutes.search:
        return (context) => SearchPage();

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

    return Navigator(
      key: navigatorKey,
      observers: [
        ShowTabBarNavigationObserver(
            hideTabBar: hideTabBar, showTabBar: showTabBar)
      ],
      initialRoute: CatalogNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => _routeBuilder(routeSettings.name,
              categories:
                  catalogRepository.catalogResponse.categories)(context),
        );
      },
    );
  }
}
