import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/cart.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/order/order_item.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/repositories/orders.dart';
import 'package:refashioned_app/screens/cart/pages/cart_page.dart';
import 'package:refashioned_app/screens/cart/pages/checkout_page.dart';
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

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function(String, String) onFinish,
  }) openDeliveryTypesSelector;

  final Function(BottomTab) changeTabTo;

  const CartNavigator(
      {Key key,
      this.navigatorKey,
      this.changeTabTo,
      this.openDeliveryTypesSelector})
      : super(key: key);

  @override
  _CartNavigatorState createState() => _CartNavigatorState();
}

class _CartNavigatorState extends State<CartNavigator> {
  OrdersRepository ordersRepository;

  @override
  initState() {
    ordersRepository = OrdersRepository();

    super.initState();
  }

  @override
  dispose() {
    ordersRepository.dispose();

    super.dispose();
  }

  Widget _routeBuilder(BuildContext context, String route,
      {Cart cart, Order order, Product product}) {
    switch (route) {
      case CartNavigatorRoutes.cart:
        return CartPage(
          openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
          onCatalogPush: () => widget.changeTabTo(BottomTab.catalog),
          onCheckoutPush: (order) => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => _routeBuilder(
                  context, CartNavigatorRoutes.checkout,
                  cart: cart, order: order),
              settings: RouteSettings(
                name: CartNavigatorRoutes.checkout,
              ),
            ),
          ),
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

              if (ordersRepository.response?.status?.code == 200)
                return Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => _routeBuilder(
                      context,
                      CartNavigatorRoutes.checkout,
                      order: ordersRepository.response.content,
                    ),
                  ),
                );
            },
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
        return CheckoutPage(
          cart: cart,
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
