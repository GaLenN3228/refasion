import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/order/order_item.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/repositories/orders.dart';
import 'package:refashioned_app/screens/cart/pages/checkout_page.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_root_page.dart';
import 'package:refashioned_app/screens/catalog/pages/category_page.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';
import 'package:refashioned_app/screens/product/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';
import 'package:refashioned_app/screens/seller/seller_page.dart';

class CatalogNavigatorRoutes {
  static const String root = '/';
  static const String categories = '/categories';
  static const String category = '/category';
  static const String products = '/products';
  static const String product = '/product';
  static const String checkout = '/checkout';
  static const String seller = '/seller';
  static const String favourites = '/favourites';
}

class CatalogNavigator extends StatefulWidget {
  CatalogNavigator(
      {this.navigatorKey, this.changeTabTo, this.openDeliveryTypesSelector});

  _CatalogNavigatorState _catalogNavigatorState;

  final Function(BottomTab) changeTabTo;
  final GlobalKey<NavigatorState> navigatorKey;

  void pushFavourites(BuildContext context) {
    var topPanelController =
        Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => _catalogNavigatorState._routeBuilder(
                context, CatalogNavigatorRoutes.favourites),
          ),
        )
        .then((value) => topPanelController.needShow = true);
  }

  void pushProducts(BuildContext context, SearchResult searchResult) {
    var topPanelController =
        Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => _catalogNavigatorState._routeBuilder(
                context, CatalogNavigatorRoutes.products,
                searchResult: searchResult),
          ),
        )
        .then((value) => topPanelController.needShow = true);
  }

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    PickPoint pickUpAddress,
    Function() onClose,
    Function(String, String) onFinish,
  }) openDeliveryTypesSelector;

  @override
  _CatalogNavigatorState createState() {
    _catalogNavigatorState = _CatalogNavigatorState();
    return _catalogNavigatorState;
  }
}

class _CatalogNavigatorState extends State<CatalogNavigator> {
  OrdersRepository ordersRepository;

  TopPanelController topPanelController;

  @override
  initState() {
    ordersRepository = OrdersRepository();

    topPanelController =
        Provider.of<TopPanelController>(context, listen: false);
    super.initState();
  }

  @override
  dispose() {
    ordersRepository.dispose();

    super.dispose();
  }

  Widget _routeBuilder(
    BuildContext context,
    String route, {
    Category category,
    List<Category> categories,
    Product product,
    Seller seller,
    String parameters,
    String productTitle,
    Order order,
    SearchResult searchResult,
  }) {
    switch (route) {
      case CatalogNavigatorRoutes.root:
        topPanelController.needShowBack = false;
        return CatalogRootPage(
          categories: categories,
          onPush: (category) {
            final newRoute = category.children.isNotEmpty
                ? CatalogNavigatorRoutes.categories
                : CatalogNavigatorRoutes.category;

            return Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) =>
                        _routeBuilder(context, newRoute, category: category),
                  ),
                )
                .then((value) => topPanelController.needShowBack = false);
          },
          onFavouritesClick: () => Navigator.of(context)
              .push(
                MaterialWithModalsPageRoute(
                  builder: (context) => _routeBuilder(
                      context, CatalogNavigatorRoutes.favourites,
                      category: category, parameters: parameters),
                ),
              )
              .then((value) => topPanelController.needShow = true),
        );

      case CatalogNavigatorRoutes.categories:
        topPanelController.needShowBack = true;
        return CategoryPage(
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
        topPanelController.needShowBack = true;
        return ChangeNotifierProvider<ProductsCountRepository>(create: (_) {
          return ProductsCountRepository()
            ..getProductsCount("?p=" + category.id);
        }, builder: (context, _) {
          return CategoryPage(
            topCategory: category,
            level: CategoryLevel.category,
            onPush: (_, {callback}) => Navigator.of(context)
                .push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                    context, CatalogNavigatorRoutes.products,
                    category: category),
                settings: RouteSettings(name: CatalogNavigatorRoutes.products),
              ),
            )
                .then((flag) {
              callback();
            }),
          );
        });

      case CatalogNavigatorRoutes.products:
        topPanelController.needShow = true;
        topPanelController.needShowBack = true;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(
            create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductsPage(
            parameters: parameters,
            searchResult: searchResult,
            topCategory: category,
            title: productTitle,
            onPush: (product, {callback}) => Navigator.of(context)
                .push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                    context, CatalogNavigatorRoutes.product,
                    product: product, category: category),
              ),
            )
                .then(
              (flag) {
                topPanelController.needShow = true;
                callback();
              },
            ),
          );
        });

      case CatalogNavigatorRoutes.product:
        topPanelController.needShow = false;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(
            create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductPage(
            product: product,
            onCartPush: () => widget.changeTabTo(BottomTab.cart),
            onProductPush: (product) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                        context, CatalogNavigatorRoutes.product,
                        product: product, category: category),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            onSellerPush: (seller) => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                    context, CatalogNavigatorRoutes.seller,
                    seller: seller),
              ),
            ),
            onSubCategoryClick: (parameters, title) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                        context, CatalogNavigatorRoutes.products,
                        product: product,
                        category: category,
                        parameters: parameters,
                        productTitle: title),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
            onCheckoutPush: (deliveryCompanyId, deliveryObjectId) async {
              final parameters = Order(
                items: [
                  OrderItem(
                    deliveryCompany: deliveryCompanyId,
                    deliveryObjectId: deliveryObjectId,
                    products: [product.id],
                  ),
                ],
              ).getParameters();

              await ordersRepository.update(parameters);

              return Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    CatalogNavigatorRoutes.checkout,
                    order: ordersRepository.response?.content,
                  ),
                ),
              );
            },
          );
        });

      case CatalogNavigatorRoutes.seller:
        return SellerPage(
          seller: seller,
          onProductPush: (product) => Navigator.of(context)
              .push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                      context, CatalogNavigatorRoutes.product,
                      product: product, category: category),
                ),
              )
              .then((value) => topPanelController.needShow = true),
        );

      case CatalogNavigatorRoutes.favourites:
        topPanelController.needShow = false;
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<FavouritesProductsRepository>(
                  create: (_) =>
                      FavouritesProductsRepository()..getFavouritesProducts()),
              ChangeNotifierProvider<AddRemoveFavouriteRepository>(
                  create: (_) => AddRemoveFavouriteRepository())
            ],
            builder: (context, _) {
              return FavouritesPage(onPush: (product) {
                Navigator.of(context)
                    .push(
                      CupertinoPageRoute(
                        builder: (context) => _routeBuilder(
                            context, CatalogNavigatorRoutes.product,
                            product: product, category: category),
                      ),
                    )
                    .then((value) => topPanelController.needShow = false);
              });
            });

      case CatalogNavigatorRoutes.checkout:
        return CheckoutPage(
          order: order,
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
        catalogRepository.getStatusCode != 200)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    return Navigator(
      key: widget.navigatorKey,
      initialRoute: CatalogNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) => _routeBuilder(context, routeSettings.name,
              categories: catalogRepository.response.content),
        );
      },
    );
  }
}
