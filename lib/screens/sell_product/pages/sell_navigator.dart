import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/sell_product/pages/category_selector.dart';
import 'package:refashioned_app/screens/sell_product/pages/section_selector.dart';
import 'package:refashioned_app/screens/sell_product/pages/subcategory_selector.dart';
import 'package:refashioned_app/screens/sell_product/pages/top_category_selector.dart';

class SellNavigatorRoutes {
  static const String root = '/';
  static const String section = '/section';
  static const String topCategory = '/topCategory';
  static const String category = '/category';
  static const String subCategory = '/subCategory';
  static const String size = '/size';
  static const String condition = '/condition';
  static const String description = '/description';
  static const String brand = '/brand';
  static const String price = '/price';
  static const String address = '/address';
  static const String newAddress = '/newAddress';
  static const String onModeration = '/onModeration';
}

class SellNavigator extends StatelessWidget {
  SellNavigator({this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  Widget _routeBuilder(BuildContext context, String route,
      {Category category,
      List<Category> categories,
      List<Filter> filters,
      Filter filter}) {
    switch (route) {
      case SellNavigatorRoutes.section:
        return SectionSelector(
          categories: categories,
          onPush: (category) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, SellNavigatorRoutes.topCategory,
                  filters: filters, category: category),
            ),
          ),
        );

      case SellNavigatorRoutes.topCategory:
        return TopCategorySelector(
          selectedSection: category,
          onPush: (category) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, SellNavigatorRoutes.category,
                  filters: filters, category: category),
            ),
          ),
        );

      case SellNavigatorRoutes.category:
        return CategorySelector(
          selectedTopCategory: category,
          onPush: (category) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, SellNavigatorRoutes.subCategory,
                  filters: filters, category: category),
            ),
          ),
        );

      case SellNavigatorRoutes.subCategory:
        return SubcategorySelector(
          selectedCategory: category,
          onPush: (categories) => Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Выбрано " + categories.length.toString() + " подкатегории"),
            ),
          ),
        );

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
          "Загрузка категорий",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );

    if (catalogRepository.loadingFailed ||
        catalogRepository.catalogResponse.status.code != 200)
      return Center(
        child: Text("Ошибка категорий",
            style: Theme.of(context).textTheme.bodyText1),
      );

    return Navigator(
      key: navigatorKey,
      initialRoute: SellNavigatorRoutes.section,
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) => _routeBuilder(context, routeSettings.name,
              categories: catalogRepository.catalogResponse.categories),
        );
      },
    );
  }
}
