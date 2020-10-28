import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/repositories/orders.dart';
import 'package:refashioned_app/screens/checkout/components/confirm_order_button.dart';
import 'package:refashioned_app/screens/checkout/components/order_item_tile.dart';
import 'package:refashioned_app/screens/checkout/components/order_payment_tile.dart';
import 'package:refashioned_app/screens/checkout/components/order_summary_tile.dart';
import 'package:refashioned_app/screens/checkout/pages/payment_page.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class CheckoutPage extends StatefulWidget {
  final Function() onClose;
  final Function(int, {bool success}) onPush;

  final Order order;

  const CheckoutPage({Key key, this.onClose, this.order, this.onPush}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ConfirmOrderRepository confirmOrderRepository;

  GetOrderRepository getOrderRepository;

  Order order;

  String paymentUrl;

  RBState buttonState;

  @override
  void initState() {
    confirmOrderRepository = ConfirmOrderRepository();

    getOrderRepository = GetOrderRepository();

    getOrder();

    buttonState = RBState.disabled;

    super.initState();
  }

  confirmOrder() async {
    setState(() => buttonState = RBState.loading);

    if (paymentUrl == null) await confirmOrderRepository.update(widget.order.id, widget.order.number);

    paymentUrl = confirmOrderRepository.response?.content;

    await showCupertinoModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isDismissible: false,
      expand: true,
      builder: (context, controller) => PaymentPage(
        initialUrl: paymentUrl,
        onFinish: () => widget.onPush?.call(order?.orderSummary?.total, success: true),
      ),
    );

    setState(() => buttonState = RBState.enabled);
  }

  getOrder() async {
    setState(() => buttonState = RBState.loading);

    await getOrderRepository.update(widget.order.id);

    order = getOrderRepository.response?.content;

    setState(() => buttonState = RBState.enabled);
  }

  @override
  void dispose() {
    confirmOrderRepository.dispose();

    getOrderRepository.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.simple(
              middleText: "Оформление заказа",
              onClose: widget.onClose ?? Navigator.of(context).pop,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                order == null
                    ? Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, MediaQuery.of(context).padding.bottom + 45.0 + 20.0),
                        children: [
                            for (final item in order.items)
                              OrderItemTile(
                                orderItem: item,
                              ),
                            OrderPaymentTile(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: OrderSummaryTile(
                                orderSummary: order.orderSummary,
                              ),
                            ),
                          ]),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).padding.bottom,
                  child: ConfirmOrderButton(
                    onPush: confirmOrder,
                    state: buttonState,
                    orderSummary: order?.orderSummary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
