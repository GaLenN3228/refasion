import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/orders.dart';
import 'package:refashioned_app/screens/cart/pages/checkout_page.dart';
import 'package:refashioned_app/screens/cart/pages/order_created_page.dart';
import 'package:refashioned_app/screens/cart/pages/payment_failed.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/components/webview_page.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';
import 'package:refashioned_app/screens/product/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';
import 'package:refashioned_app/screens/seller/pages/select_seller_rating.dart';
import 'package:refashioned_app/screens/seller/pages/send_seller_review.dart';
import 'package:refashioned_app/screens/seller/pages/seller_page.dart';
import 'package:refashioned_app/screens/seller/pages/seller_reviews.dart';
import 'home.dart';

class HomeNavigatorRoutes {
  static const String root = '/';
  static const String products = '/products';
  static const String product = '/product';
  static const String seller = '/seller';
  static const String sellerReviews = '/seller_reviews';
  static const String selectSellerRating = '/add_seller_rating';
  static const String sendSellerReview = '/add_seller_review';
  static const String favourites = '/favourites';
  static const String checkout = '/checkout';
  static const String orderCreated = '/order_created';
  static const String paymentFailed = '/payment_failed';
  static const String doc = '/doc';
}

class HomeNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    switch (previousRoute?.settings?.name) {
      case HomeNavigatorRoutes.seller:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;

      default:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
    }

    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    switch (route?.settings?.name) {
      case HomeNavigatorRoutes.seller:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;

      default:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
    }
    super.didPush(route, previousRoute);
  }
}

class HomeNavigator extends StatefulWidget {
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_HomeNavigatorState>()
      : context.findAncestorStateOfType<_HomeNavigatorState>();

  final Function(BottomTab) changeTabTo;
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(PickPoint) openPickUpAddressMap;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function() onFinish,
    Future<bool> Function(String, String) onSelect,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  HomeNavigator({this.navigatorKey, this.changeTabTo, this.openPickUpAddressMap, this.openDeliveryTypesSelector});

  void pushFavourites(BuildContext context) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => HomeNavigator.of(context)._routeBuilder(
              context,
              HomeNavigatorRoutes.favourites,
            ),
            settings: RouteSettings(
              name: HomeNavigatorRoutes.favourites,
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
        builder: (context) => HomeNavigator.of(context)._routeBuilder(
          context,
          HomeNavigatorRoutes.products,
          searchResult: searchResult,
        ),
        settings: RouteSettings(
          name: HomeNavigatorRoutes.products,
        ),
      ),
    )
        .then((value) {
      topPanelController.needShow = true;
      topPanelController.needShowBack = false;
    });
  }

  @override
  _HomeNavigatorState createState() {
    return _HomeNavigatorState();
  }
}

class _HomeNavigatorState extends State<HomeNavigator> {
  CreateOrderRepository createOrderRepository;

  Order order;
  int totalPrice;

  Seller seller;
  int rating;

  @override
  initState() {
    createOrderRepository = CreateOrderRepository();

    super.initState();
  }

  @override
  dispose() {
    createOrderRepository.dispose();

    super.dispose();
  }

  Widget _routeBuilder(BuildContext context, String route,
      {Category category,
      Product product,
      String parameters,
      String productTitle,
      SearchResult searchResult,
      String collectionUrl,
      String url,
      String urlName}) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    switch (route) {
      case HomeNavigatorRoutes.root:
        topPanelController.needShowBack = false;
        return HomePage(
          pushProduct: (product) {
            Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      HomeNavigatorRoutes.product,
                      product: product,
                    ),
                    settings: RouteSettings(
                      name: HomeNavigatorRoutes.product,
                    ),
                  ),
                )
                .then((value) => topPanelController.needShow = true);
          },
          pushCollection: (url, title) {
            Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      HomeNavigatorRoutes.products,
                      collectionUrl: url,
                      productTitle: title,
                    ),
                    settings: RouteSettings(
                      name: HomeNavigatorRoutes.products,
                    ),
                  ),
                )
                .then((value) => {topPanelController.needShow = true, topPanelController.needShowBack = false});
          },
          onDocPush: (String url, String urlName) {
            Navigator.of(context)
                .push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                  context,
                  HomeNavigatorRoutes.doc,
                  url: url,
                  urlName: urlName,
                ),
                settings: RouteSettings(
                  name: HomeNavigatorRoutes.doc,
                ),
              ),
            )
                .then(
              (flag) {
                topPanelController.needShow = true;
              },
            );
          },
        );

      case HomeNavigatorRoutes.products:
        topPanelController.needShow = true;
        topPanelController.needShowBack = true;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductsPage(
            collectionUrl: collectionUrl,
            parameters: parameters,
            searchResult: searchResult,
            topCategory: category,
            title: productTitle,
            onPush: (product, {callback}) => Navigator.of(context)
                .push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                  context,
                  HomeNavigatorRoutes.product,
                  product: product,
                  category: category,
                ),
                settings: RouteSettings(
                  name: HomeNavigatorRoutes.product,
                ),
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

      case HomeNavigatorRoutes.product:
        topPanelController.needShow = false;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductPage(
            product: product,
            onCartPush: () => widget.changeTabTo(BottomTab.cart),
            onPickupAddressPush: widget.openPickUpAddressMap?.call,
            onProductPush: (product) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      HomeNavigatorRoutes.product,
                      product: product,
                      category: category,
                    ),
                    settings: RouteSettings(
                      name: HomeNavigatorRoutes.product,
                    ),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            onSellerPush: (newSeller) {
              seller = newSeller;

              Navigator.of(context).pushNamed(HomeNavigatorRoutes.seller);
            },
            onSubCategoryClick: (parameters, title) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      HomeNavigatorRoutes.products,
                      product: product,
                      category: category,
                      parameters: parameters,
                      productTitle: title,
                    ),
                    settings: RouteSettings(
                      name: HomeNavigatorRoutes.products,
                    ),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
            onCheckoutPush: (Order newOrder) {
              if (newOrder != null) {
                order = newOrder;

                Navigator.of(context).pushNamed(HomeNavigatorRoutes.checkout);
              }
            },
          );
        });

      case HomeNavigatorRoutes.seller:
        topPanelController.needShow = false;
        topPanelController.needShowBack = false;
        return SellerPage(
          seller: seller,
          onSellerReviewsPush: () {
            final newRoute =
                seller.reviewsCount > 0 ? HomeNavigatorRoutes.sellerReviews : HomeNavigatorRoutes.sellerReviews;

            Navigator.of(context).pushNamed(newRoute);
          },
          onProductPush: (product) => Navigator.of(context)
              .push(
                CupertinoPageRoute(
                  builder: (context) => _routeBuilder(
                    context,
                    HomeNavigatorRoutes.product,
                    product: product,
                    category: category,
                  ),
                  settings: RouteSettings(
                    name: HomeNavigatorRoutes.product,
                  ),
                ),
              )
              .then((value) => topPanelController.needShow = true),
        );

      case HomeNavigatorRoutes.sellerReviews:
        topPanelController.needShow = false;
        topPanelController.needShowBack = false;
        return SellerReviewsPage(
          seller: seller,
          onAddSellerRatingPush: () => Navigator.of(context).pushNamed(HomeNavigatorRoutes.selectSellerRating),
        );

      case HomeNavigatorRoutes.selectSellerRating:
        topPanelController.needShow = false;
        topPanelController.needShowBack = false;
        return SelectSellerRatingPage(
          seller: seller,
          onAddSellerReviewPush: (int newRating) {
            rating = newRating;
            Navigator.of(context).pushNamed(HomeNavigatorRoutes.sendSellerReview);
          },
        );

      case HomeNavigatorRoutes.sendSellerReview:
        topPanelController.needShow = false;
        topPanelController.needShowBack = false;
        return SendSellerReviewPage(
          seller: seller,
          rating: rating,
          onPush: () => Navigator.of(context).pushNamedAndRemoveUntil(
            HomeNavigatorRoutes.sellerReviews,
            (route) => route.settings.name == HomeNavigatorRoutes.seller,
          ),
        );

      case HomeNavigatorRoutes.favourites:
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
                          HomeNavigatorRoutes.product,
                          product: product,
                          category: category,
                        ),
                        settings: RouteSettings(
                          name: HomeNavigatorRoutes.product,
                        ),
                      ),
                    )
                    .then((value) => topPanelController.needShow = false);
              },
            );
          },
        );

      case HomeNavigatorRoutes.checkout:
        return CheckoutPage(
          order: order,
          onPush: (newTotalPrice, {bool success}) async {
            totalPrice = newTotalPrice;

            await Navigator.of(context).pushReplacementNamed(
              success ?? false ? HomeNavigatorRoutes.orderCreated : HomeNavigatorRoutes.paymentFailed,
            );
          },
        );

      case HomeNavigatorRoutes.orderCreated:
        return OrderCreatedPage(
          totalPrice: totalPrice,
          onUserOrderPush: () => widget.changeTabTo(
            BottomTab.profile,
          ),
        );

      case HomeNavigatorRoutes.paymentFailed:
        return PaymentFailedPage(
          totalPrice: totalPrice,
        );

      case HomeNavigatorRoutes.doc:
        topPanelController.needShow = false;
        return WebViewPage(
          initialUrl: url,
          title: urlName,
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
  Widget build(BuildContext context) => Navigator(
        key: widget.navigatorKey,
        initialRoute: HomeNavigatorRoutes.root,
        observers: [
          HomeNavigatorObserver(),
        ],
        onGenerateInitialRoutes: (navigatorState, initialRoute) => [
          CupertinoPageRoute(
            builder: (context) => _routeBuilder(
              context,
              initialRoute,
            ),
            settings: RouteSettings(
              name: initialRoute,
            ),
          ),
        ],
        onGenerateRoute: (routeSettings) => CupertinoPageRoute(
          builder: (context) => _routeBuilder(
            context,
            routeSettings.name,
          ),
          settings: routeSettings,
        ),
      );
}
