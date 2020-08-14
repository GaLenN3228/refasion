import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/product_count.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_root_page.dart';
import 'package:refashioned_app/screens/catalog/pages/category_page.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/catalog/search/search_page.dart';
import 'package:refashioned_app/screens/product/pages/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';
import 'package:refashioned_app/screens/seller/seller_page.dart';

class CatalogNavigatorRoutes {
  static const String root = '/';
  static const String categories = '/categories';
  static const String category = '/category';
  static const String products = '/products';
  static const String product = '/product';
  static const String seller = '/seller';
}

class CatalogNavigator extends StatelessWidget {
  CatalogNavigator({this.navigatorKey, this.onPushPageOnTop});
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(Widget) onPushPageOnTop;

  Widget _routeBuilder(BuildContext context, String route,
      {Category category,
      List<Category> categories,
      Product product,
      Seller seller}) {
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
          onPush: (category, {callback}) {
            final newRoute = category.children.isNotEmpty
                ? CatalogNavigatorRoutes.category
                : CatalogNavigatorRoutes.products;

            return Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) =>
                        _routeBuilder(context, newRoute, category: category),
                    settings: RouteSettings(name: newRoute),
                  ),
                )
                .then((flag) => callback(category: category));
          },
        );

      case CatalogNavigatorRoutes.category:
        return ChangeNotifierProvider<ProductCountRepository>(create: (_) {
          return ProductCountRepository(parameters: "?p=" + category.id);
        }, builder: (context, _) {
          return CategoryPage(
            onSearch: () => onPushPageOnTop(SearchPage()),
            topCategory: category,
            level: CategoryLevel.category,
            onPush: (_, {callback}) => Navigator.of(context)
                .push(
              MaterialWithModalsPageRoute(
                builder: (context) => _routeBuilder(
                    context, CatalogNavigatorRoutes.products,
                    category: category),
              ),
            )
                .then((flag) {
              callback();
            }),
          );
        });

      case CatalogNavigatorRoutes.products:
        return ProductsPage(
          onSearch: () => onPushPageOnTop(SearchPage()),
          topCategory: category,
          onPush: (product) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CatalogNavigatorRoutes.product,
                  product: product),
            ),
          ),
        );

      case CatalogNavigatorRoutes.product:
        return ProductPage(
          product: product,
          onProductPush: (product) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CatalogNavigatorRoutes.product,
                  product: product),
            ),
          ),
          onSellerPush: (seller) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CatalogNavigatorRoutes.seller,
                  seller: seller),
            ),
          ),
        );

      case CatalogNavigatorRoutes.seller:
        return SellerPage(
          seller: seller,
          onProductPush: (product) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CatalogNavigatorRoutes.product,
                  product: product),
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
