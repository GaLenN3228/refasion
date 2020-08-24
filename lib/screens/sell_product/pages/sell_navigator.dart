import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/sell_properties.dart';
import 'package:refashioned_app/screens/sell_product/pages/addresses_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/brand_page.dart';
import 'package:refashioned_app/screens/sell_product/pages/cards_page.dart';
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
  static const String section = '/section';
  static const String topCategory = '/topCategory';
  static const String category = '/category';
  static const String subCategory = '/subCategory';
  static const String photos = '/photos';
  static const String sellProperty = '/sellProperty';
  static const String description = '/description';
  static const String brand = '/brand';
  static const String price = '/price';
  static const String cards = '/cards';
  static const String addresses = '/addresses';
  static const String newAddress = '/newAddress';
  static const String onModeration = '/onModeration';
}

class SellNavigatorObserver extends NavigatorObserver {
  final Map<String, FocusNode> focusNodes;
  final BuildContext context;

  SellNavigatorObserver({this.context, this.focusNodes});

  @override
  void didPop(Route route, Route previousRoute) {
    final previousRouteName = previousRoute?.settings?.name;
    final routeName = route?.settings?.name;

    if (!focus(previousRouteName)) unfocus(routeName);

    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    final routeName = route?.settings?.name;
    final previousRouteName = previousRoute?.settings?.name;

    if (!focus(routeName)) unfocus(previousRouteName);

    super.didPush(route, previousRoute);
  }

  bool focus(String routeName) {
    if (routeName != null) {
      final focusNode = focusNodes[routeName];
      if (focusNode == null) {
        return false;
      }
      focusNode.requestFocus();
      return true;
    } else {
      return false;
    }
  }

  unfocus(String routeName) {
    if (routeName != null) focusNodes[routeName]?.unfocus();
  }
}

class SellNavigator extends StatefulWidget {
  SellNavigator({this.onClose});

  final Function() onClose;

  final List<String> pagesWithFocusNodes = [
    SellNavigatorRoutes.description,
    SellNavigatorRoutes.brand,
    SellNavigatorRoutes.price,
  ];

  @override
  _SellNavigatorState createState() => _SellNavigatorState();
}

class SellProductData {
  Category category;

  int price;

  Brand brand;

  String description;

  List<SellProperty> properties;

  List<String> photos;

  String address;

  String card;

  updateCategory(Category newCategory) => category = newCategory;

  updatePhotos(List<String> newPhotos) => photos = newPhotos;

  updateAddress(String newAddress) => address = newAddress;

  updateCard(String newCard) => card = newCard;

  updatePrice(int newPrice) => price = newPrice;

  updateBrand(Brand newBrand) => brand = newBrand;

  updateDescription(String newDescription) => description = newDescription;

  updateProperties(SellProperty newSellProperty) =>
      properties.add(newSellProperty);
}

class _SellNavigatorState extends State<SellNavigator> {
  SellPropertiesRepository sellPropertiesRepository;

  Map<String, FocusNode> focusNodes;

  SellNavigatorObserver sellNavigatorObserver;

  SellProductData productData;

  String brandSearchQuery;

  @override
  initState() {
    focusNodes = Map.fromIterable(widget.pagesWithFocusNodes,
        key: (route) => route, value: (_) => new FocusNode());

    sellNavigatorObserver =
        SellNavigatorObserver(context: context, focusNodes: focusNodes);

    productData = SellProductData();

    super.initState();
  }

  @override
  dispose() {
    focusNodes.values.forEach((focusNode) => focusNode.dispose());

    super.dispose();
  }

  Widget _routeBuilder(BuildContext context, String route,
      {Category category,
      List<Category> categories,
      List<SellProperty> sellProperties,
      int sellPropertyIndex: 0}) {
    switch (route) {
      case SellNavigatorRoutes.section:
        return WillPopScope(
          onWillPop: () async => false,
          child: SectionPage(
            sections: categories,
            onClose: widget.onClose,
            onPush: (category) => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                    context, SellNavigatorRoutes.topCategory,
                    category: category),
                settings: RouteSettings(name: SellNavigatorRoutes.topCategory),
              ),
            ),
          ),
        );

      case SellNavigatorRoutes.topCategory:
        return TopCategoryPage(
          section: category,
          onClose: widget.onClose,
          onPush: (category) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, SellNavigatorRoutes.category,
                  category: category),
              settings: RouteSettings(name: SellNavigatorRoutes.category),
            ),
          ),
        );

      case SellNavigatorRoutes.category:
        return CategoryPage(
          topCategory: category,
          onClose: widget.onClose,
          onPush: (category) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, SellNavigatorRoutes.subCategory,
                  category: category),
              settings: RouteSettings(name: SellNavigatorRoutes.subCategory),
            ),
          ),
        );

      case SellNavigatorRoutes.subCategory:
        return SubcategoryPage(
          topCategory: category,
          onClose: widget.onClose,
          initialData: productData.category,
          onUpdate: () => productData.updateCategory(category),
          onPush: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                    context, SellNavigatorRoutes.photos,
                    categories: categories),
                settings: RouteSettings(name: SellNavigatorRoutes.photos),
              ),
            );
          },
        );

      case SellNavigatorRoutes.photos:
        return PhotosPage(
          onClose: widget.onClose,
          initialData: productData.photos,
          onUpdate: (photos) => productData.updatePhotos(photos),
          onPush: () {
            final hasSellProperties = (sellPropertiesRepository != null &&
                sellPropertiesRepository.isLoaded &&
                sellPropertiesRepository.response.status.code == 200 &&
                sellPropertiesRepository
                    .response.content.requiredProperties.isNotEmpty);

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) {
                  if (hasSellProperties)
                    return _routeBuilder(
                        context, SellNavigatorRoutes.sellProperty,
                        sellProperties: sellPropertiesRepository
                            .response.content.requiredProperties);
                  else
                    return _routeBuilder(
                        context, SellNavigatorRoutes.description);
                },
                settings: RouteSettings(
                    name: hasSellProperties
                        ? SellNavigatorRoutes.sellProperty
                        : SellNavigatorRoutes.description),
              ),
            );
          },
        );

      case SellNavigatorRoutes.sellProperty:
        final sellProperty = sellProperties.elementAt(sellPropertyIndex);

        return SellPropertyPage(
          onClose: widget.onClose,
          sellProperty: sellProperty,
          initialData: productData.properties,
          onUpdate: () => productData.updateProperties(sellProperty),
          onPush: () {
            if (sellPropertyIndex < sellProperties.length - 1)
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                      context, SellNavigatorRoutes.sellProperty,
                      sellProperties: sellProperties,
                      sellPropertyIndex: sellPropertyIndex + 1),
                  settings:
                      RouteSettings(name: SellNavigatorRoutes.sellProperty),
                ),
              );
            else
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) =>
                      _routeBuilder(context, SellNavigatorRoutes.description),
                  settings:
                      RouteSettings(name: SellNavigatorRoutes.description),
                ),
              );
          },
        );

      case SellNavigatorRoutes.description:
        return DescriptionPage(
            onClose: widget.onClose,
            focusNode: focusNodes[route],
            initialData: productData.description,
            onUpdate: (description) =>
                productData.updateDescription(description),
            onPush: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) =>
                      _routeBuilder(context, SellNavigatorRoutes.brand),
                  settings: RouteSettings(name: SellNavigatorRoutes.brand),
                ),
              );
            });

      case SellNavigatorRoutes.brand:
        return BrandPage(
          onClose: widget.onClose,
          focusNode: focusNodes[route],
          initialQuery: brandSearchQuery,
          initialData: productData.brand,
          onUpdate: (query, brand) {
            brandSearchQuery = query;
            productData.updateBrand(brand);
          },
          onPush: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) =>
                    _routeBuilder(context, SellNavigatorRoutes.price),
                settings: RouteSettings(name: SellNavigatorRoutes.price),
              ),
            );
          },
        );

      case SellNavigatorRoutes.price:
        return PricePage(
          onClose: widget.onClose,
          focusNode: focusNodes[route],
          initialData: productData.price,
          onUpdate: (price) => productData.updatePrice(price),
          onPush: () {
            Navigator.of(context).push(
              MaterialWithModalsPageRoute(
                builder: (context) =>
                    _routeBuilder(context, SellNavigatorRoutes.cards),
                settings: RouteSettings(name: SellNavigatorRoutes.cards),
              ),
            );
          },
        );

      case SellNavigatorRoutes.cards:
        return CardsPage(
          onClose: widget.onClose,
          initialData: productData.card,
          onUpdate: (card) => productData.updateCard(card),
          onPush: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) =>
                    _routeBuilder(context, SellNavigatorRoutes.addresses),
                settings: RouteSettings(name: SellNavigatorRoutes.addresses),
              ),
            );
          },
        );

      case SellNavigatorRoutes.addresses:
        return AddressesPage(
          onClose: widget.onClose,
          initialData: productData.address,
          onUpdate: (address) => productData.updateAddress(address),
          onPush: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) =>
                    _routeBuilder(context, SellNavigatorRoutes.newAddress),
                settings: RouteSettings(name: SellNavigatorRoutes.newAddress),
              ),
            );
          },
          onSkip: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) =>
                    _routeBuilder(context, SellNavigatorRoutes.onModeration),
                settings: RouteSettings(name: SellNavigatorRoutes.onModeration),
              ),
            );
          },
        );

      case SellNavigatorRoutes.newAddress:
        return NewAddressPage(
          onPush: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) =>
                    _routeBuilder(context, SellNavigatorRoutes.onModeration),
                settings: RouteSettings(name: SellNavigatorRoutes.onModeration),
              ),
            );
          },
        );

      case SellNavigatorRoutes.onModeration:
        return WillPopScope(
          onWillPop: () async => false,
          child: OnModerationPage(
            onClose: widget.onClose,
          ),
        );

      default:
        return Center(
          child: Text("Default"),
        );
    }
  }

  selectSubCategories(Category topCategory) {
    sellPropertiesRepository =
        SellPropertiesRepository(category: topCategory.id);
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
        catalogRepository.response.status.code != 200)
      return Center(
        child: Text("Ошибка категорий",
            style: Theme.of(context).textTheme.bodyText1),
      );

    return Navigator(
      initialRoute: SellNavigatorRoutes.section,
      observers: [sellNavigatorObserver],
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) => _routeBuilder(context, routeSettings.name,
              categories: catalogRepository.response.content),
          settings: routeSettings,
        );
      },
    );
  }
}
