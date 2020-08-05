import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/sell_properties.dart';
import 'package:refashioned_app/screens/sell_product/pages/addresses_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/brand_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/category_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/description_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/new_address_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/on_moderation_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/photos_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/price_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/section_page.dart';
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
  static const String description = '/description';
  static const String brand = '/brand';
  static const String price = '/price';
  static const String addresses = '/addresses';
  static const String newAddress = '/newAddress';
  static const String onModeration = '/onModeration';
}

class SellNavigator extends StatefulWidget {
  SellNavigator({this.onClose});

  final Function() onClose;

  @override
  _SellNavigatorState createState() => _SellNavigatorState();
}

class _SellNavigatorState extends State<SellNavigator> {
  SellPropertiesRepository sellPropertiesRepository;

  Widget _routeBuilder(BuildContext context, String route,
      {Category category,
      List<Category> categories,
      List<SellProperty> sellProperties,
      int sellPropertyIndex: 0}) {
    switch (route) {
      case SellNavigatorRoutes.section:
        return SectionPage(
          categories: categories,
          onClose: widget.onClose,
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
          onClose: widget.onClose,
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
          onClose: widget.onClose,
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
          onClose: widget.onClose,
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
          onClose: widget.onClose,
          onPush: () {
            addPhotos(null);

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) {
                  if (sellPropertiesRepository != null &&
                          sellPropertiesRepository.isLoaded ||
                      sellPropertiesRepository.response.status.code == 200)
                    return _routeBuilder(
                        context, SellNavigatorRoutes.sellProperty,
                        sellProperties:
                            sellPropertiesRepository.response.content);
                  else
                    return _routeBuilder(
                        context, SellNavigatorRoutes.description);
                },
              ),
            );
          },
        );

      case SellNavigatorRoutes.sellProperty:
        final sellProperty = sellProperties.elementAt(sellPropertyIndex);
        return SellPropertyPage(
          onClose: widget.onClose,
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
        return DescriptionPage(
            onClose: widget.onClose,
            onPush: (description) {
              addDescription(description);
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) =>
                      _routeBuilder(context, SellNavigatorRoutes.brand),
                ),
              );
            });

      case SellNavigatorRoutes.brand:
        return BrandPage(
            onClose: widget.onClose,
            onPush: (brand) {
              selectBrand(brand);
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) =>
                      _routeBuilder(context, SellNavigatorRoutes.price),
                ),
              );
            });

      case SellNavigatorRoutes.price:
        return PricePage(
            onClose: widget.onClose,
            onPush: (price) {
              selectPrice(price);
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) =>
                      _routeBuilder(context, SellNavigatorRoutes.addresses),
                ),
              );
            });

      case SellNavigatorRoutes.addresses:
        return AddressesPage(
            onClose: widget.onClose,
            onPush: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) =>
                      _routeBuilder(context, SellNavigatorRoutes.newAddress),
                ),
              );
            });

      case SellNavigatorRoutes.newAddress:
        return NewAddressPage(onPush: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  _routeBuilder(context, SellNavigatorRoutes.onModeration),
            ),
          );
        });

      case SellNavigatorRoutes.onModeration:
        return OnModerationPage(
          onClose: widget.onClose,
        );

      default:
        return Center(
          child: Text("Default"),
        );
    }
  }

  selectSubCategories(List<Category> categories) {
    sellPropertiesRepository = SellPropertiesRepository();
  }

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
