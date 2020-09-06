import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/cart/cart/pages/cart_page.dart';
import 'package:refashioned_app/screens/cart/cart/pages/checkout_page.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/product/product.dart';

class CartNavigatorRoutes {
  static const String cart = '/';
  static const String product = '/product';
  static const String seller = '/seller';
  static const String checkout = '/checkout';
}

class CartNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(DeliveryType, Address, Function()) pushDeliveryNavigator;
  final Function(BottomTab) changeTabTo;

  const CartNavigator(
      {Key key,
      this.navigatorKey,
      this.pushDeliveryNavigator,
      this.changeTabTo})
      : super(key: key);

  @override
  _CartNavigatorState createState() => _CartNavigatorState();
}

class _CartNavigatorState extends State<CartNavigator> {
  Widget _routeBuilder(BuildContext context, String route, {Product product}) {
    switch (route) {
      case CartNavigatorRoutes.cart:
        return CartPage(
          onDeliveryOptionPush: widget.pushDeliveryNavigator,
          onProductPush: (product) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                context,
                CartNavigatorRoutes.product,
                product: product,
              ),
              settings: RouteSettings(
                name: CartNavigatorRoutes.product,
              ),
            ),
          ),
        );

      case CartNavigatorRoutes.product:
        return ChangeNotifierProvider<AddRemoveFavouriteRepository>(
          create: (_) => AddRemoveFavouriteRepository(),
          builder: (context, _) => ProductPage(
            product: product,
            onCartPush: () => widget.changeTabTo(BottomTab.cart),
            onProductPush: (product) => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                  context,
                  CartNavigatorRoutes.product,
                  product: product,
                ),
                settings: RouteSettings(
                  name: CartNavigatorRoutes.product,
                ),
              ),
            ),
          ),
        );

      case CartNavigatorRoutes.checkout:
        return CheckoutPage();

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
