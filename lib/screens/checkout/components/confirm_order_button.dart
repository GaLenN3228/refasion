import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/models/order/order_summary.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/button/data/decoration.dart';
import 'package:refashioned_app/screens/components/button/data/label_data.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';
import 'package:refashioned_app/utils/colors.dart';

class ConfirmOrderButton extends StatefulWidget {
  final OrderSummary orderSummary;
  final RBState state;

  final Function() onPush;

  const ConfirmOrderButton({Key key, this.orderSummary, this.onPush, this.state}) : super(key: key);

  @override
  _ConfirmOrderButtonState createState() => _ConfirmOrderButtonState();
}

class _ConfirmOrderButtonState extends State<ConfirmOrderButton> {
  RBData buttonData;

  int oldTotal;

  @override
  void initState() {
    buttonData = RBData.map(
      initState: RBState.disabled,
      data: {
        RBState.enabled: RBStateData.enabled(
          title: "Оплатить",
          onTap: () => widget.onPush?.call(),
        ),
        RBState.disabled: RBStateData.disabled(
          title: "Оплатить",
        ),
        RBState.loading: RBStateData.loading(),
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    buttonData.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ConfirmOrderButton oldWidget) {
    final newTotal = widget.orderSummary?.total;

    switch (widget.state) {
      case RBState.enabled:
        if (newTotal != null) {
          final numberFormat = NumberFormat("#,###", "ru_Ru");

          buttonData.updateStateData(
            RBState.enabled,
            RBStateData.simple(
              decoration: RBDecorationData.ofStyle(RBDecoration.black),
              label: RBLabelData.ofTitle(
                "Оплатить - ${numberFormat.format(newTotal)} ₽",
                color: white,
                titleAnimation: RBContentAnimation.typing,
                initialTitle: buttonData.state != RBState.disabled ? "" : "Оплатить",
              ),
              onTap: widget.onPush?.call,
            ),
            notify: false,
          );

          oldTotal = newTotal;

          buttonData.setState(
            RBState.enabled,
            animateTitleOut: buttonData.state != RBState.disabled,
          );
        }

        break;

      case RBState.loading:
        buttonData.setState(RBState.loading);

        break;

      default:
        buttonData.setState(
          RBState.disabled,
          animateTitleIn: buttonData.state != RBState.enabled,
          animateTitleOut: buttonData.state != RBState.enabled,
        );

        break;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => RefashionedButton(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        data: buttonData,
      );
}
