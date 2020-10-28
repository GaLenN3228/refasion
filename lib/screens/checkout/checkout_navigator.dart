import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/screens/checkout/pages/checkout_page.dart';
import 'package:refashioned_app/screens/checkout/pages/order_created_page.dart';
import 'package:refashioned_app/screens/checkout/pages/payment_failed.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';

class CheckoutNavigatorRoutes {
  static const String checkout = '/';
  static const String orderCreated = '/order_created';
  static const String paymentFailed = '/payment_failed';
}

class CheckoutNavigator extends StatefulWidget {
  final Order order;
  final Function(BottomTab) changeTabTo;
  final Function() onClose;

  const CheckoutNavigator({Key key, @required this.changeTabTo, @required this.order, this.onClose}) : super(key: key);

  @override
  _CheckoutNavigatorState createState() => _CheckoutNavigatorState();
}

class _CheckoutNavigatorState extends State<CheckoutNavigator> {
  Order order;
  int totalPrice;

  @override
  initState() {
    order = widget.order;

    super.initState();
  }

  Widget _routeBuilder(
    BuildContext context,
    String route,
  ) {
    switch (route) {
      case CheckoutNavigatorRoutes.checkout:
        return CheckoutPage(
          order: order,
          onClose: widget.onClose,
          onPush: (newTotalPrice, {bool success}) async {
            totalPrice = newTotalPrice;

            await Navigator.of(context).pushReplacementNamed(
              success ?? false ? CheckoutNavigatorRoutes.orderCreated : CheckoutNavigatorRoutes.paymentFailed,
            );
          },
        );

      case CheckoutNavigatorRoutes.orderCreated:
        return OrderCreatedPage(
          totalPrice: totalPrice,
          onClose: widget.onClose,
          onUserOrderPush: () => widget.changeTabTo(
            BottomTab.profile,
          ),
        );

      case CheckoutNavigatorRoutes.paymentFailed:
        return PaymentFailedPage(
          totalPrice: totalPrice,
          onClose: widget.onClose,
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
        initialRoute: CheckoutNavigatorRoutes.checkout,
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
