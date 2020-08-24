import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/cart/pages/cart.dart';
import 'package:refashioned_app/screens/product/pages/product.dart';

class CartNavigatorRoutes {
  static const String cart = '/';
  static const String product = '/product';
  static const String seller = '/seller';
}

class CartNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final bool needUpdate;

  const CartNavigator({Key key, this.navigatorKey, this.needUpdate: true})
      : super(key: key);

  @override
  _CartNavigatorState createState() => _CartNavigatorState();
}

class _CartNavigatorState extends State<CartNavigator> {
  Widget _routeBuilder(BuildContext context, String route, {Product product}) {
    switch (route) {
      case CartNavigatorRoutes.cart:
        return CartPage(
          needUpdate: widget.needUpdate,
          onProductPush: (product) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CartNavigatorRoutes.product,
                  product: product),
              settings: RouteSettings(name: CartNavigatorRoutes.product),
            ),
          ),
        );

      case CartNavigatorRoutes.product:
        return ProductPage(
          product: product,
          onProductPush: (product) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CartNavigatorRoutes.product,
                  product: product),
              settings: RouteSettings(name: CartNavigatorRoutes.product),
            ),
          ),
        );

      default:
        return CupertinoPageScaffold(
          backgroundColor: Colors.white,
          child: Center(
            child: Text(
              "Default",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Navigator(
        initialRoute: CartNavigatorRoutes.cart,
        key: widget.navigatorKey,
        onGenerateRoute: (routeSettings) => CupertinoPageRoute(
          builder: (context) => _routeBuilder(context, routeSettings.name),
          settings: routeSettings,
        ),
      );
}
