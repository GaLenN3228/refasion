import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/sell_product/pages/addresses_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/brand_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/category_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/description_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/new_adress_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/on_moderation_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/photos_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/price_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/section_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/sell_properties_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/sell_property_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/subcategory_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/top_category_page.dart';

class SellNavigatorRoutes {
  static const String root = '/';
  static const String section = '/section';
  static const String topCategory = '/topCategory';
  static const String category = '/category';
  static const String subCategory = '/subCategory';
  static const String photos = '/photos';
  static const String sellProperty = '/sellProperty';
  static const String sellProperties = '/sellProperties';
  static const String description = '/description';
  static const String brand = '/brand';
  static const String price = '/price';
  static const String addresses = '/addresses';
  static const String newAddress = '/newAddress';
  static const String onModeration = '/onModeration';
}

class SellNavigator extends StatelessWidget {
  SellNavigator({this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  Widget _routeBuilder(BuildContext context, String route,
      {Category category,
      List<Category> categories,
      List<SellProperty> sellProperties,
      int sellPropertyIndex}) {
    switch (route) {
      case SellNavigatorRoutes.section:
        return SectionPage(
          categories: categories,
          onPush: (category) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, SellNavigatorRoutes.topCategory,
                  category: category),
            ),
          ),
        );

      case SellNavigatorRoutes.topCategory:
        return TopCategoryPage(
          selectedSection: category,
          onPush: (category) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, SellNavigatorRoutes.category,
                  category: category),
            ),
          ),
        );

      case SellNavigatorRoutes.category:
        return CategoryPage(
          selectedTopCategory: category,
          onPush: (category) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, SellNavigatorRoutes.subCategory,
                  category: category),
            ),
          ),
        );

      case SellNavigatorRoutes.subCategory:
        return SubcategoryPage(
          selectedCategory: category,
          onPush: (categories) {
            selectSubCategories(categories);
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                    context, SellNavigatorRoutes.photos,
                    categories: categories),
              ),
            );
          },
        );

      case SellNavigatorRoutes.photos:
        return PhotosPage(
          onPush: (photos) {
            addPhotos(photos);
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                    context, SellNavigatorRoutes.sellProperties,
                    categories: categories),
              ),
            );
          },
        );

      case SellNavigatorRoutes.sellProperties:
        PageRouteBuilder noAnimationRoute(String route,
                {List<SellProperty> sellProperties, int sellPropertyIndex}) =>
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 0),
                pageBuilder: (context, animation, seondaryAnimation) =>
                    _routeBuilder(context, route,
                        sellProperties: sellProperties,
                        sellPropertyIndex: sellPropertyIndex));

        return SellPropertiesPage(
          categories: categories,
          onPush: (sellProperties) => Navigator.of(context).push(
            noAnimationRoute(SellNavigatorRoutes.sellProperty,
                sellProperties: sellProperties, sellPropertyIndex: 0),
          ),
          onSkip: () => Navigator.of(context).push(
            noAnimationRoute(SellNavigatorRoutes.description),
          ),
        );

      case SellNavigatorRoutes.sellProperty:
        final sellProperty = sellProperties.elementAt(sellPropertyIndex);
        return SellPropertyPage(
          sellProperty: sellProperty,
          onPush: () {
            selectPropertyValue(sellProperty);
            if (sellPropertyIndex < sellProperties.length - 1)
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                      context, SellNavigatorRoutes.sellProperty,
                      sellProperties: sellProperties,
                      sellPropertyIndex: sellPropertyIndex + 1),
                ),
              );
            else
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) =>
                      _routeBuilder(context, SellNavigatorRoutes.description),
                ),
              );
          },
        );

      case SellNavigatorRoutes.description:
        return DescriptionPage(onPush: (description) {
          addDescription(description);
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  _routeBuilder(context, SellNavigatorRoutes.brand),
            ),
          );
        });

      case SellNavigatorRoutes.brand:
        return BrandPage(onPush: (brand) {
          selectBrand(brand);
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  _routeBuilder(context, SellNavigatorRoutes.price),
            ),
          );
        });

      case SellNavigatorRoutes.price:
        return PricePage(onPush: (price) {
          selectPrice(price);
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  _routeBuilder(context, SellNavigatorRoutes.addresses),
            ),
          );
        });

      case SellNavigatorRoutes.addresses:
        return AddressesPage(onPush: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  _routeBuilder(context, SellNavigatorRoutes.newAddress),
            ),
          );
        });

      case SellNavigatorRoutes.newAddress:
        return NewAdressPage(onPush: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  _routeBuilder(context, SellNavigatorRoutes.onModeration),
            ),
          );
        });

      case SellNavigatorRoutes.onModeration:
        return OnModerationPage();

      default:
        return Center(
          child: Text("Default"),
        );
    }
  }

  selectSubCategories(List<Category> categories) {}

  addPhotos(List<String> photos) {}

  selectPrice(int price) {}

  selectBrand(Brand brand) {}

  addDescription(String description) {}

  selectPropertyValue(SellProperty sellPropery) {}

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
