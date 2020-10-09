import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/repositories/orders.dart';

import 'package:refashioned_app/screens/cart/components/tiles/order_item_tile.dart';
import 'package:refashioned_app/screens/cart/components/tiles/order_payment_tile.dart';
import 'package:refashioned_app/screens/cart/components/tiles/order_summary_tile.dart';
import 'package:refashioned_app/screens/cart/pages/payment_page.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class CheckoutPage extends StatefulWidget {
  final Function() onClose;
  final Function(int) onOrderCreatedPush;

  final Order order;

  const CheckoutPage({Key key, this.onClose, this.order, this.onOrderCreatedPush}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ConfirmOrderRepository confirmOrderRepository;

  GetOrderRepository getOrderRepository;

  UpdateOrderRepository updateOrderRepository;

  Order order;

  String paymentUrl;

  ValueNotifier<ButtonState> buttonState;

  Map<ButtonState, ButtonData> buttonStatesData;

  @override
  void initState() {
    confirmOrderRepository = ConfirmOrderRepository();

    getOrderRepository = GetOrderRepository();

    updateOrderRepository = UpdateOrderRepository();

    buttonState = ValueNotifier(ButtonState.disabled);

    buttonStatesData = {
      ButtonState.enabled: ButtonData(
        buttonContainerData: ButtonContainerData(
          decorationType: ButtonDecorationType.black,
        ),
        titleData: ButtonTitleData(
          text: "Оплатить - " + order?.orderSummary?.total.toString() + " ₽",
          color: ButtonTitleColor.white,
        ),
      ),
      ButtonState.disabled: ButtonData(
        buttonContainerData: ButtonContainerData(
          decorationType: ButtonDecorationType.gray,
        ),
        titleData: ButtonTitleData(
          text: "Оплатить",
          color: ButtonTitleColor.white,
        ),
      ),
    };

    getOrder();

    super.initState();
  }

  confirmOrder() async {
    if (buttonState.value == ButtonState.enabled) {
      if (paymentUrl == null) await confirmOrderRepository.update(widget.order.id, widget.order.number);

      paymentUrl = confirmOrderRepository.response?.content;

      showCupertinoModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isDismissible: false,
        expand: true,
        builder: (context, controller) => PaymentPage(
          initialUrl: paymentUrl,
          onFinish: () => widget.onOrderCreatedPush?.call(order?.orderSummary?.total),
        ),
      );
    }
  }

  getOrder() async {
    // await setPaymentMethod();

    await getOrderRepository.update(widget.order.id);

    setState(() => order = getOrderRepository.response?.content);

    final totalPrice = order?.orderSummary?.total;

    if (totalPrice != null) {
      buttonStatesData[ButtonState.enabled] = ButtonData(
        buttonContainerData: ButtonContainerData(
          decorationType: ButtonDecorationType.black,
        ),
        titleData: ButtonTitleData(
          text: "Оплатить - " + totalPrice.toString() + " ₽",
          color: ButtonTitleColor.white,
        ),
      );

      buttonState.value = ButtonState.enabled;
    } else
      buttonState.value = ButtonState.disabled;
  }

  setPaymentMethod() async {
    await updateOrderRepository.update(widget.order.id, jsonEncode({"id": widget.order.id, "payment_type": "online"}));
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
              onBack: Navigator.of(context).pop,
              onClose: widget.onClose,
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
                        padding:
                            EdgeInsets.fromLTRB(15, 0, 15, MediaQuery.of(context).padding.bottom + 65.0 + 45.0 + 20.0),
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
                  bottom: MediaQuery.of(context).padding.bottom + 65.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RefashionedButton(
                      onTap: confirmOrder,
                      animateContent: false,
                      states: buttonState,
                      statesData: buttonStatesData,
                    ),
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
