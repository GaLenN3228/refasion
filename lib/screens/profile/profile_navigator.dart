import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/authorization.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/products/pages/favourites.dart';
import 'package:refashioned_app/screens/product/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';
import 'package:refashioned_app/screens/profile/loginned_profile.dart';
import 'package:refashioned_app/screens/profile/map_page.dart';
import 'package:refashioned_app/screens/profile/profile.dart';
import 'package:refashioned_app/screens/profile/settings.dart';

class ProfileNavigatorRoutes {
  static const String root = '/';
  static const String settings = '/settings';
  static const String products = '/products';
  static const String product = '/product';
  static const String favourites = '/favourites';
}

class ProfileNavigator extends StatefulWidget {
  final Function(BottomTab) changeTabTo;
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(Widget) pushPageOnTop;

  ProfileNavigator({this.navigatorKey, this.changeTabTo, this.pushPageOnTop});

  _ProfileNavigatorState _mapPageState;

  void pushFavourites(BuildContext context, bool needShowTopBar) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) => _mapPageState._routeBuilder(context, ProfileNavigatorRoutes.favourites),
          ),
        )
        .then((value) => topPanelController.needShow = needShowTopBar);
  }

  void pushProducts(BuildContext context, SearchResult searchResult) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (context) =>
                _mapPageState._routeBuilder(context, ProfileNavigatorRoutes.products, searchResult: searchResult),
          ),
        )
        .then((value) => topPanelController.needShow = true);
  }

  @override
  _ProfileNavigatorState createState() {
    _mapPageState = _ProfileNavigatorState();
    return _mapPageState;
  }
}

class _ProfileNavigatorState extends State<ProfileNavigator> {
  Widget _routeBuilder(BuildContext context, String route,
      {bool isAuthorized,
      Category category,
      Product product,
      Seller seller,
      String parameters,
      String productTitle,
      SearchResult searchResult}) {
    var topPanelController = Provider.of<TopPanelController>(context, listen: false);
    switch (route) {
      case ProfileNavigatorRoutes.root:
        topPanelController.needShowBack = true;
        topPanelController.needShow = false;
        return isAuthorized
            ? AuthorizedProfilePage(
                onFavClick: () {
                  widget.pushFavourites(context, false);
                },
                onSettingsClick: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) =>
                          _routeBuilder(context, ProfileNavigatorRoutes.settings, isAuthorized: isAuthorized),
                    ),
                  );
                },
              )
            : ProfilePage(
                onSettingsClick: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) =>
                          _routeBuilder(context, ProfileNavigatorRoutes.settings, isAuthorized: isAuthorized),
                    ),
                  );
                },
                onMapPageClick: () {
                  widget.pushPageOnTop(MapPage());
                },
              );

      case ProfileNavigatorRoutes.settings:
        return isAuthorized
            ? SettingForAuthUser(
                onMapPageClick: () {
                  widget.pushPageOnTop(MapPage());
                },
              )
            : SettingPage();

      case ProfileNavigatorRoutes.products:
        topPanelController.needShow = true;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
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
                builder: (context) =>
                    _routeBuilder(context, ProfileNavigatorRoutes.product, product: product, category: category),
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

      case ProfileNavigatorRoutes.product:
        topPanelController.needShow = false;
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductPage(
            product: product,
            onCartPush: () => widget.changeTabTo(BottomTab.cart),
            onProductPush: (product) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) =>
                        _routeBuilder(context, ProfileNavigatorRoutes.product, product: product, category: category),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
            onSubCategoryClick: (parameters, title) => Navigator.of(context)
                .push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(context, ProfileNavigatorRoutes.products,
                        product: product, category: category, parameters: parameters, productTitle: title),
                    settings: RouteSettings(name: ProfileNavigatorRoutes.products),
                  ),
                )
                .then((value) => topPanelController.needShow = false),
          );
        });

      case ProfileNavigatorRoutes.favourites:
        topPanelController.needShow = false;
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<FavouritesProductsRepository>(
                  create: (_) => FavouritesProductsRepository()..getFavouritesProducts()),
              ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) => AddRemoveFavouriteRepository())
            ],
            builder: (context, _) {
              return FavouritesPage(onPush: (product) {
                Navigator.of(context)
                    .push(
                      CupertinoPageRoute(
                        builder: (context) => _routeBuilder(context, ProfileNavigatorRoutes.product,
                            product: product, category: category),
                      ),
                    )
                    .then((value) => topPanelController.needShow = false);
              });
            });

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
    context.watch<CodeAuthorizationRepository>();
    return FutureBuilder<bool>(
      future: BaseRepository.isAuthorized(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return Navigator(
            key: widget.navigatorKey,
            initialRoute: ProfileNavigatorRoutes.root,
            onGenerateRoute: (routeSettings) {
              return CupertinoPageRoute(
                builder: (context) => _routeBuilder(context, routeSettings.name, isAuthorized: snapshot.data),
              );
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
