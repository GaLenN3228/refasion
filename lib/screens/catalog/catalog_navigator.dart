import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/cart/pages/checkout_page.dart';
import 'package:refashioned_app/screens/cart/pages/order_created_page.dart';
import 'package:refashioned_app/screens/cart/pages/payment_failed.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_root_page.dart';
import 'package:refashioned_app/screens/catalog/pages/category_brands_page.dart';
import 'package:refashioned_app/screens/catalog/pages/category_page.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';
import 'package:refashioned_app/screens/product/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';
import 'package:refashioned_app/screens/seller/seller_page.dart';
import 'package:refashioned_app/utils/colors.dart';

class CatalogNavigatorRoutes {
  static const String root = '/';
  static const String categories = '/categories';
  static const String category = '/category';
  static const String brands = '/brands';
  static const String products = '/products';
  static const String product = '/product';
  static const String seller = '/seller';
  static const String checkout = '/checkout';
  static const String orderCreated = '/order_created';
  static const String paymentFailed = '/payment_failed';
  static const String favourites = '/favourites';
}

class CatalogNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    switch (previousRoute?.settings?.name) {
      case CatalogNavigatorRoutes.seller:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;

      case CatalogNavigatorRoutes.product:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;

      default:
        break;
    }

    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    switch (route?.settings?.name) {
      case CatalogNavigatorRoutes.seller:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;

      case CatalogNavigatorRoutes.product:
      case CatalogNavigatorRoutes.checkout:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;

      default:
        break;
    }
    super.didPush(route, previousRoute);
  }
}

class CatalogNavigator extends StatefulWidget {
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_CatalogNavigatorState>()
      : context.findAncestorStateOfType<_CatalogNavigatorState>();

  CatalogNavigator({this.navigatorKey, this.changeTabTo, this.openDeliveryTypesSelector, this.openPickUpAddressMap});

  final Function(BottomTab) changeTabTo;
  final GlobalKey<NavigatorState> navigatorKey;

  final Function(PickPoint) openPickUpAddressMap;

  void pushFavourites(BuildContext context) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => CatalogNavigator.of(context)._routeBuilder(
              context,
              CatalogNavigatorRoutes.favourites,
            ),
            settings: RouteSettings(
              name: CatalogNavigatorRoutes.favourites,
            ),
          ),
        )
        .then((value) => topPanelController.needShow = true);
  }

  void pushProducts(BuildContext context, SearchResult searchResult) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
      CupertinoPageRoute(
        builder: (context) => CatalogNavigator.of(context)._routeBuilder(
          context,
          CatalogNavigatorRoutes.products,
          searchResult: searchResult,
        ),
        settings: RouteSettings(
          name: CatalogNavigatorRoutes.products,
        ),
      ),
    )
        .then((value) {
      topPanelController.needShow = true;
      topPanelController.needShowBack = false;
    });
  }

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function() onFinish,
    Future<bool> Function(String, String) onSelect,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  @override
  _CatalogNavigatorState createState() {
    return _CatalogNavigatorState();
  }
}

class _CatalogNavigatorState extends State<CatalogNavigator> {
  Order order;
  int totalPrice;

  TopPanelController topPanelController;

  Seller seller;

  @override
  initState() {
    topPanelController = Provider.of<TopPanelController>(context, listen: false);
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Widget _routeBuilder(
    BuildContext context,
    String route, {
    Category category,
    List<Category> categories,
    Product product,
    String parameters,
    String productTitle,
    SearchResult searchResult,
    List<Brand> brands,
  }) {
    switch (route) {
      case CatalogNavigatorRoutes.root:
        topPanelController.needShowBack = false;
        return CatalogRootPage(
          categories: categories,
          onPush: (category) {
            final newRoute =
                category.children.isNotEmpty ? CatalogNavigatorRoutes.categories : CatalogNavigatorRoutes.category;

            return Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      newRoute,
                      category: category,
                    ),
                    settings: RouteSettings(
                      name: newRoute,
                    ),
                  ),
                )
                .then((value) => topPanelController.needShowBack = false);
          },
          onFavouritesClick: () {
            return Navigator.of(context)
                .push(
                  MaterialWithModalsPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      CatalogNavigatorRoutes.favourites,
                      category: category,
                      parameters: parameters,
                    ),
                    settings: RouteSettings(
                      name: CatalogNavigatorRoutes.favourites,
                    ),
                  ),
                )
                .then((value) => topPanelController.needShow = true);
          },
        );

      case CatalogNavigatorRoutes.categories:
        topPanelController.needShowBack = true;
        return CategoryPage(
          topCategory: category,
          level: CategoryLevel.categories,
          onPush: (category, {callback}) {
            final newRoute =
                category.children.isNotEmpty ? CatalogNavigatorRoutes.category : CatalogNavigatorRoutes.products;

            return Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      newRoute,
                      category: category,
                    ),
                    settings: RouteSettings(
                      name: newRoute,
                    ),
                  ),
                )
                .then((flag) => callback(category: category));
          },
        );

      case CatalogNavigatorRoutes.category:
        topPanelController.needShowBack = true;
        return ChangeNotifierProvider<ProductsCountRepository>(create: (_) {
          return ProductsCountRepository()..getProductsCount("?p=" + category.id);
        }, builder: (context, _) {
          return CategoryPage(
            topCategory: category,
            level: CategoryLevel.category,
            onPush: (_, {callback}) {
              Provider.of<CategoryBrandsRepository>(context, listen: false).response = null;

              return Navigator.of(context)
                  .push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    CatalogNavigatorRoutes.products,
                    category: category,
                  ),
                  settings: RouteSettings(
                    name: CatalogNavigatorRoutes.products,
                  ),
                ),
              )
                  .then((flag) {
                callback();
              });
            },
            onBrandsPush: ({callback}) {
              Navigator.of(context)
                  .push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    CatalogNavigatorRoutes.brands,
                    category: category,
                  ),
                  settings: RouteSettings(
                    name: CatalogNavigatorRoutes.brands,
                  ),
                ),
              )
                  .then((flag) {
                callback();
              });
            },
          );
        });

      case CatalogNavigatorRoutes.brands:
        topPanelController.needShowBack = true;
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<ProductsCountRepository>(
                  create: (_) => ProductsCountRepository()..getProductsCount("?p=" + category.id)),
            ],
            builder: (context, _) {
              return CategoryBrandsPage(
                topCategory: category,
                onPush: (_, brands, {callback}) {
                  return Navigator.of(context)
                      .push(
                    CupertinoPageRoute(
                      builder: (context) => _routeBuilder(
                        context,
                        CatalogNavigatorRoutes.products,
                        category: category,
                        brands: brands,
                      ),
                      settings: RouteSettings(
                        name: CatalogNavigatorRoutes.products,
                      ),
                    ),
                  )
                      .then((flag) {
                    callback();
                  });
                },
              );
            });

      case CatalogNavigatorRoutes.products:
        topPanelController.needShow = true;
        topPanelController.needShowBack = true;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductsPage(
            parameters: parameters,
            searchResult: searchResult,
            topCategory: category,
            title: productTitle,
            onPush: (product, {callback}) {
              return Navigator.of(context)
                  .push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    CatalogNavigatorRoutes.product,
                    product: product,
                    category: category,
                  ),
                  settings: RouteSettings(
                    name: CatalogNavigatorRoutes.product,
                  ),
                ),
              )
                  .then(
                (flag) {
                  topPanelController.needShow = true;
                  // callback();
                },
              );
            },
          );
        });

      case CatalogNavigatorRoutes.product:
        topPanelController.needShow = false;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductPage(
            product: product,
            onCartPush: () => widget.changeTabTo(BottomTab.cart),
            onProductPush: (product) {
              return Navigator.of(context)
                  .push(
                    CupertinoPageRoute(
                      builder: (context) => _routeBuilder(
                        context,
                        CatalogNavigatorRoutes.product,
                        product: product,
                        category: category,
                      ),
                      settings: RouteSettings(
                        name: CatalogNavigatorRoutes.product,
                      ),
                    ),
                  )
                  .then((value) => topPanelController.needShow = false);
            },
            onSellerPush: (newSeller) {
              seller = newSeller;

              Navigator.of(context).pushNamed(CatalogNavigatorRoutes.seller);
            },
            onSubCategoryClick: (parameters, title) {
              return Navigator.of(context)
                  .push(
                    CupertinoPageRoute(
                      builder: (context) => _routeBuilder(
                        context,
                        CatalogNavigatorRoutes.products,
                        product: product,
                        parameters: parameters,
                        productTitle: title,
                      ),
                      settings: RouteSettings(
                        name: CatalogNavigatorRoutes.products,
                      ),
                    ),
                  )
                  .then((value) => topPanelController.needShow = false);
            },
            openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
            onCheckoutPush: (Order newOrder) {
              if (newOrder != null) {
                order = newOrder;

                Navigator.of(context).pushNamed(CatalogNavigatorRoutes.checkout);
              }
            },
            onPickupAddressPush: widget.openPickUpAddressMap?.call,
          );
        });

      case CatalogNavigatorRoutes.seller:
        return SellerPage(
          seller: seller,
          onProductPush: (product) => Navigator.of(context)
              .push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    CatalogNavigatorRoutes.product,
                    product: product,
                    category: category,
                  ),
                  settings: RouteSettings(
                    name: CatalogNavigatorRoutes.product,
                  ),
                ),
              )
              .then((value) => topPanelController.needShow = false),
        );

      case CatalogNavigatorRoutes.favourites:
        topPanelController.needShow = false;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<FavouritesProductsRepository>(
                create: (_) => FavouritesProductsRepository()..getFavouritesProducts()),
            ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) => AddRemoveFavouriteRepository())
          ],
          builder: (context, _) {
            return FavouritesPage(
              onCatalogPush: () => widget.changeTabTo(BottomTab.catalog),
              onPush: (product) {
                Navigator.of(context)
                    .push(
                      CupertinoPageRoute(
                        builder: (context) => _routeBuilder(
                          context,
                          CatalogNavigatorRoutes.product,
                          product: product,
                          category: category,
                        ),
                        settings: RouteSettings(
                          name: CatalogNavigatorRoutes.product,
                        ),
                      ),
                    )
                    .then((value) => topPanelController.needShow = false);
              },
            );
          },
        );

      case CatalogNavigatorRoutes.checkout:
        return CheckoutPage(
          order: order,
          onPush: (newTotalPrice, {bool success}) async {
            totalPrice = newTotalPrice;

            await Navigator.of(context).pushReplacementNamed(
              success ?? false ? CatalogNavigatorRoutes.orderCreated : CatalogNavigatorRoutes.paymentFailed,
            );
          },
        );

      case CatalogNavigatorRoutes.orderCreated:
        return OrderCreatedPage(
          totalPrice: totalPrice,
          onUserOrderPush: () => widget.changeTabTo(
            BottomTab.profile,
          ),
        );

      case CatalogNavigatorRoutes.paymentFailed:
        return PaymentFailedPage(
          totalPrice: totalPrice,
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
          child: SizedBox(
        height: 32.0,
        width: 32.0,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: accentColor,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ));

    if (catalogRepository.loadingFailed || catalogRepository.getStatusCode != 200)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    return Navigator(
      key: widget.navigatorKey,
      initialRoute: CatalogNavigatorRoutes.root,
      observers: [
        CatalogNavigatorObserver(),
      ],
      onGenerateInitialRoutes: (navigatorState, initialRoute) => [
        CupertinoPageRoute(
          builder: (context) => _routeBuilder(
            context,
            initialRoute,
            categories: catalogRepository.response.content,
          ),
          settings: RouteSettings(
            name: initialRoute,
          ),
        )
      ],
      onGenerateRoute: (routeSettings) => CupertinoPageRoute(
        builder: (context) => _routeBuilder(
          context,
          routeSettings.name,
          categories: catalogRepository.response.content,
        ),
        settings: routeSettings,
      ),
    );
  }
}
