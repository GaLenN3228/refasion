import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/cart_summary.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/button/data/decoration.dart';
import 'package:refashioned_app/screens/components/button/data/label_data.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';
import 'package:refashioned_app/utils/colors.dart';

class CreateOrderButton extends StatefulWidget {
  final CartSummary cartSummary;
  final RBState state;
  final Function() onPush;

  const CreateOrderButton({Key key, this.cartSummary, this.onPush, this.state}) : super(key: key);

  @override
  _CreateOrderButtonState createState() => _CreateOrderButtonState();
}

class _CreateOrderButtonState extends State<CreateOrderButton> {
  RBData buttonData;

  String oldCaption;

  @override
  void initState() {
    buttonData = RBData.map(
      initState: RBState.loading,
      data: {
        RBState.enabled: RBStateData.enabled(
          title: "Перейти к оформлению",
          onTap: () => widget.onPush?.call(),
        ),
        RBState.disabled: RBStateData.disabled(
          title: "Перейти к оформлению",
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
  void didUpdateWidget(covariant CreateOrderButton oldWidget) {
    switch (widget.state) {
      case RBState.enabled:
        if (widget.cartSummary.canOrder) {
          if (oldCaption != widget.cartSummary.buttonCaption) {
            if (buttonData.state == RBState.enabled)
              buttonData.setState(
                RBState.disabled,
                animateTitleOut: false,
                animateTitleIn: false,
              );

            buttonData.updateStateData(
              RBState.enabled,
              RBStateData.simple(
                decoration: RBDecorationData.ofStyle(RBDecoration.black),
                label: RBLabelData.ofTitle(
                  "Перейти к оформлению",
                  caption: widget.cartSummary.buttonCaption,
                  color: white,
                  titleAnimation: RBContentAnimation.fade,
                  captionAnimation: RBContentAnimation.size,
                ),
                onTap: widget.onPush?.call,
              ),
              notify: false,
            );

            oldCaption = widget.cartSummary.buttonCaption;
          }

          buttonData.setState(
            RBState.enabled,
            animateTitleOut: buttonData.state != RBState.disabled,
            animateTitleIn: buttonData.state != RBState.disabled,
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
