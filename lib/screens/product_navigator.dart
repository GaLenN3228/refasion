import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/product/product.dart';

class ProductNavigatorRoutes {
  static const String product = '/';
}

class ProductNavigator extends StatelessWidget {
  ProductNavigator({this.productKey, this.product, this.screenKey, this.pushPageOnTop});

  final GlobalKey<NavigatorState> productKey;
  final GlobalKey<NavigatorState> screenKey;
  final Product product;
  final Function(String, String) pushPageOnTop;

  Widget routeBuilder(BuildContext context, String route,
      {Category category,
      Product product,
      Seller seller,
      String parameters,
      String productTitle,
      SearchResult searchResult}) {
    switch (route) {
      case ProductNavigatorRoutes.product:
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(create: (_) {
          return AddRemoveFavouriteRepository();
        }, builder: (context, _) {
          return ProductPage(
            // screenKey: screenKey,
            // productKey: productKey,
            product: product,
            onProductPush: (product) => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => routeBuilder(context, ProductNavigatorRoutes.product, product: product, category: category),
              ),
            ),
//            onSellerPush: (seller) => Navigator.of(context).push(
//              CupertinoPageRoute(
//                builder: (context) => routeBuilder(context, CatalogNavigatorRoutes.seller, seller: seller),
//              ),
//            ),
           onSubCategoryClick: (parameters, title) => pushPageOnTop(parameters, title)
          );
        });

      default:
        return CupertinoPageScaffold(
          child: Center(
            child: Text(
              "Неизвестный маршрут000: " + route.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: productKey,
      initialRoute: ProductNavigatorRoutes.product,
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) =>
              routeBuilder(context, routeSettings.name, product: product),
        );
      },
    );
  }
}
