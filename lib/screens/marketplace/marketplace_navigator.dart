import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/models/size.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/repositories/sell_properties.dart';
import 'package:refashioned_app/repositories/size.dart';
import 'package:refashioned_app/screens/marketplace/components/take_option_tile.dart';
import 'package:refashioned_app/screens/marketplace/pages/addresses_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/brand_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/cards_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/category_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/description_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/new_address_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/photos_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/pickpoints_map_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/price_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/section_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/sell_property_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/sizes_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/sizes_value.dart';
import 'package:refashioned_app/screens/marketplace/pages/subcategory_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/take_options_page.dart';
import 'package:refashioned_app/screens/marketplace/pages/top_category_page.dart';

class MarketplaceNavigatorRoutes {
  static const String section = '/section';
  static const String topCategory = '/topCategory';
  static const String category = '/category';
  static const String subCategory = '/subCategory';
  static const String photos = '/photos';
  static const String sellProperty = '/sellProperty';
  static const String description = '/description';
  static const String brand = '/brand';
  static const String sizes = '/sizes';
  static const String sizesValue = '/sizesValue';
  static const String price = '/price';
  static const String cards = '/cards';
  static const String addresses = '/addresses';
  static const String newAddress = '/newAddress';
  static const String takeOptions = '/takeOptions';
  static const String pickUpPoints = '/pickUpPoints';
  static const String onModeration = '/onModeration';
}

class MarketplaceNavigatorObserver extends NavigatorObserver {
  final Map<String, FocusNode> focusNodes;
  final BuildContext context;

  MarketplaceNavigatorObserver({this.context, this.focusNodes});

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

class MarketplaceNavigator extends StatefulWidget {
  MarketplaceNavigator({this.onClose, this.onProductCreated});

  final Function() onClose;
  final Function() onProductCreated;

  final List<String> pagesWithFocusNodes = [
    MarketplaceNavigatorRoutes.description,
    MarketplaceNavigatorRoutes.brand,
    MarketplaceNavigatorRoutes.price,
  ];

  @override
  _MarketplaceNavigatorState createState() => _MarketplaceNavigatorState();
}

class ProductData {
  Category category;

  int price;

  Brand brand;

  String description;

  List<SellProperty> properties = List();

  List<String> photos;

  PickPoint address;

  List<TakeOption> options;

  String card;

  Values sizes;

  updateCategory(Category newCategory) => category = newCategory;

  updatePhotos(List<String> newPhotos) => photos = newPhotos;

  updateAddress(PickPoint newAddress) => address = newAddress;

  updateTakeOptions(List<TakeOption> newOptions) => options = newOptions;

  updateCard(String newCard) => card = newCard;

  updatePrice(int newPrice) => price = newPrice;

  updateBrand(Brand newBrand) => brand = newBrand;

  updateDescription(String newDescription) => description = newDescription;

  updateProperties(SellProperty newSellProperty) => properties.add(newSellProperty);

  updateSizes(Values sizes) => this.sizes = sizes;
}

class _MarketplaceNavigatorState extends State<MarketplaceNavigator> {
  SellPropertiesRepository sellPropertiesRepository;

  Map<String, FocusNode> focusNodes;

  MarketplaceNavigatorObserver sellNavigatorObserver;

  ProductData productData;

  String brandSearchQuery;

  @override
  initState() {
    focusNodes = Map.fromIterable(widget.pagesWithFocusNodes, key: (route) => route, value: (_) => new FocusNode());

    sellNavigatorObserver = MarketplaceNavigatorObserver(context: context, focusNodes: focusNodes);

    productData = ProductData();

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
      int sellPropertyIndex: 0,
      Sizes size}) {
    switch (route) {
      case MarketplaceNavigatorRoutes.section:
        return WillPopScope(
          onWillPop: () async => false,
          child: SectionPage(
            sections: categories,
            onClose: widget.onClose,
            onPush: (category) {
              return Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) =>
                      _routeBuilder(context, MarketplaceNavigatorRoutes.topCategory, category: category),
                  settings: RouteSettings(name: MarketplaceNavigatorRoutes.topCategory),
                ),
              );
            },
          ),
        );

      case MarketplaceNavigatorRoutes.topCategory:
        return TopCategoryPage(
          section: category,
          onClose: widget.onClose,
          onPush: (category) {
            return Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.category, category: category),
                settings: RouteSettings(name: MarketplaceNavigatorRoutes.category),
              ),
            );
          },
        );

      case MarketplaceNavigatorRoutes.category:
        return CategoryPage(
            topCategory: category,
            onClose: widget.onClose,
            onPush: (pushedCategory) {
              if (pushedCategory.children.isNotEmpty) {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) =>
                        _routeBuilder(context, MarketplaceNavigatorRoutes.subCategory, category: pushedCategory),
                    settings: RouteSettings(name: MarketplaceNavigatorRoutes.subCategory),
                  ),
                );
              } else {
                sellPropertiesRepository = SellPropertiesRepository();
                sellPropertiesRepository.getProperties(category.id);

                var sizeRepository = Provider.of<SizeRepository>(context, listen: false);
                sizeRepository.getSizes(category.id);

                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.photos,
                        categories: categories, category: pushedCategory),
                    settings: RouteSettings(name: MarketplaceNavigatorRoutes.photos),
                  ),
                );
              }
            });

      case MarketplaceNavigatorRoutes.subCategory:
        return SubcategoryPage(
          topCategory: category,
          onClose: widget.onClose,
          initialData: productData.category,
          onUpdate: () => productData.updateCategory(category),
          onPush: (chosenCategory) {
            productData.updateCategory(chosenCategory);

            sellPropertiesRepository = SellPropertiesRepository();
            sellPropertiesRepository.getProperties(category.id);

            var sizeRepository = Provider.of<SizeRepository>(context, listen: false);
            sizeRepository.getSizes(chosenCategory.id);

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.photos,
                    categories: categories, category: chosenCategory),
                settings: RouteSettings(name: MarketplaceNavigatorRoutes.photos),
              ),
            );
          },
        );

      case MarketplaceNavigatorRoutes.photos:
        return PhotosPage(
          onClose: widget.onClose,
          initialData: productData.photos,
          onUpdate: (photos) => productData.updatePhotos(photos),
          onPush: () {
            final hasSellProperties = (sellPropertiesRepository != null &&
                sellPropertiesRepository.isLoaded &&
                sellPropertiesRepository.response.status.code == 200 &&
                sellPropertiesRepository.response.content.requiredProperties.isNotEmpty);

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) {
                  if (hasSellProperties)
                    return _routeBuilder(context, MarketplaceNavigatorRoutes.sizes,
                        sellProperties: sellPropertiesRepository.response.content.requiredProperties,
                        category: category);
                  else
                    return _routeBuilder(context, MarketplaceNavigatorRoutes.sizes);
                },
                settings: RouteSettings(
                    name: hasSellProperties
                        ? MarketplaceNavigatorRoutes.sellProperty
                        : MarketplaceNavigatorRoutes.description),
              ),
            );
          },
        );

      case MarketplaceNavigatorRoutes.sizes:
        return SizesPage(
          onBack: Navigator.of(context).pop,
          onPush: (sizes) {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) {
                  return _routeBuilder(context, MarketplaceNavigatorRoutes.sizesValue, size: sizes);
                },
              ),
            );
          },
        );

      case MarketplaceNavigatorRoutes.sizesValue:
        return SizeValuesPage(
          sizes: size,
          onBack: Navigator.of(context).pop,
          onPush: (sizeValue) {
            productData.updateSizes(sizeValue);
            final hasSellProperties = (sellPropertiesRepository != null &&
                sellPropertiesRepository.isLoaded &&
                sellPropertiesRepository.response.status.code == 200 &&
                sellPropertiesRepository.response.content.requiredProperties.isNotEmpty);

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) {
                  if (hasSellProperties)
                    return _routeBuilder(context, MarketplaceNavigatorRoutes.sellProperty,
                        sellProperties: sellPropertiesRepository.response.content.requiredProperties);
                  else
                    return _routeBuilder(context, MarketplaceNavigatorRoutes.description);
                },
                settings: RouteSettings(
                    name: hasSellProperties
                        ? MarketplaceNavigatorRoutes.sellProperty
                        : MarketplaceNavigatorRoutes.description),
              ),
            );
          },
        );

      case MarketplaceNavigatorRoutes.sellProperty:
        final sellProperty = sellProperties.elementAt(sellPropertyIndex);

        return SellPropertyPage(
          onClose: widget.onClose,
          sellProperty: sellProperty,
          initialData: productData.properties,
          onUpdate: () => productData.updateProperties(sellProperty),
          onPush: () {
            productData.updateProperties(sellProperty);

            if (sellPropertyIndex < sellProperties.length - 1)
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.sellProperty,
                      sellProperties: sellProperties, sellPropertyIndex: sellPropertyIndex + 1),
                  settings: RouteSettings(name: MarketplaceNavigatorRoutes.sellProperty),
                ),
              );
            else
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.description),
                  settings: RouteSettings(name: MarketplaceNavigatorRoutes.description),
                ),
              );
          },
        );

      case MarketplaceNavigatorRoutes.description:
        return DescriptionPage(
            onClose: widget.onClose,
            focusNode: focusNodes[route],
            initialData: productData.description,
            onUpdate: (description) => productData.updateDescription(description),
            onPush: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.brand),
                  settings: RouteSettings(name: MarketplaceNavigatorRoutes.brand),
                ),
              );
            });

      case MarketplaceNavigatorRoutes.brand:
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
                builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.price),
                settings: RouteSettings(name: MarketplaceNavigatorRoutes.price),
              ),
            );
          },
        );

      case MarketplaceNavigatorRoutes.price:
        return ChangeNotifierProvider<CalcProductPrice>(create: (_) {
          return CalcProductPrice();
        }, builder: (context, _) {
          return PricePage(
            onClose: widget.onClose,
            focusNode: focusNodes[route],
            initialData: productData.price,
            onUpdate: (price) => productData.updatePrice(price),
            onPush: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.addresses),
                  settings: RouteSettings(name: MarketplaceNavigatorRoutes.addresses),
                ),
              );
            },
          );
        });

      case MarketplaceNavigatorRoutes.cards:
        return CardsPage(
          onClose: widget.onClose,
          initialData: productData.card,
          onUpdate: (card) => productData.updateCard(card),
          onPush: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.addresses),
                settings: RouteSettings(name: MarketplaceNavigatorRoutes.addresses),
              ),
            );
          },
        );

      case MarketplaceNavigatorRoutes.addresses:
        return AddressesPage(
          onClose: widget.onClose,
          initialData: productData.address,
          onUpdate: (address) => productData.updateAddress(address),
          onPush: () {
            Navigator.of(context).push(
              MaterialWithModalsPageRoute(
                builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.newAddress),
                settings: RouteSettings(name: MarketplaceNavigatorRoutes.newAddress),
              ),
            );
          },
          onSkip: () {
            AddProductRepository().addProduct(productData);
            widget.onProductCreated();
          },
        );

      case MarketplaceNavigatorRoutes.newAddress:
        return NewAddressPage(
          onAddressPush: (address) {
            productData.updateAddress(address);

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.takeOptions),
                settings: RouteSettings(name: MarketplaceNavigatorRoutes.takeOptions),
              ),
            );
          },
        );

      case MarketplaceNavigatorRoutes.takeOptions:
        return TakeOptionsPage(
          address: productData.address,
          onPush: (options) {
            productData.updateTakeOptions(options);
            AddProductRepository().addProduct(productData);
            widget.onProductCreated();
          },
          showPickUpPoints: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(context, MarketplaceNavigatorRoutes.pickUpPoints),
                settings: RouteSettings(name: MarketplaceNavigatorRoutes.pickUpPoints),
              ),
            );
          },
        );

      case MarketplaceNavigatorRoutes.pickUpPoints:
        return PickpointsMapPage(
          address: productData.address,
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

    if (catalogRepository.loadingFailed || catalogRepository.response.status.code != 200)
      return Center(
        child: Text("Ошибка категорий", style: Theme.of(context).textTheme.bodyText1),
      );

    return Navigator(
      initialRoute: MarketplaceNavigatorRoutes.section,
      observers: [sellNavigatorObserver],
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) =>
              _routeBuilder(context, routeSettings.name, categories: catalogRepository.response.content),
          settings: routeSettings,
        );
      },
    );
  }
}
