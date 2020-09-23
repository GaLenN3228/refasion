import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/cart_summary.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';

class CartOrderButton extends StatefulWidget {
  final CartSummary cartSummary;
  final Function() onCheckoutPush;

  const CartOrderButton({Key key, this.cartSummary, this.onCheckoutPush}) : super(key: key);

  @override
  _CartOrderButtonState createState() => _CartOrderButtonState();
}

class _CartOrderButtonState extends State<CartOrderButton> {
  ValueNotifier<ButtonState> buttonState;
  Map<ButtonState, ButtonData> buttonStatesData;

  @override
  initState() {
    buttonStatesData = {
      ButtonState.enabled: ButtonData(
        buttonContainerData: ButtonContainerData(
          decorationType: ButtonDecorationType.black,
        ),
        titleData: ButtonTitleData(
          text: "Перейти к оформлению",
          color: ButtonTitleColor.white,
        ),
      ),
      ButtonState.disabled: ButtonData(
        buttonContainerData: ButtonContainerData(
          decorationType: ButtonDecorationType.gray,
        ),
        titleData: ButtonTitleData(
          text: "Перейти к оформлению",
          color: ButtonTitleColor.white,
        ),
      ),
    };

    buttonState = ValueNotifier(ButtonState.disabled);

    super.initState();
  }

  onCheckoutPush() {
    if (buttonState.value == ButtonState.enabled) {
      widget.onCheckoutPush?.call();
    }
  }

  @override
  void dispose() {
    buttonState.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buttonState.value = widget.cartSummary.canOrder ? ButtonState.enabled : ButtonState.disabled;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RefashionedButton(
        states: buttonState,
        statesData: buttonStatesData,
        animateContent: false,
        onTap: onCheckoutPush,
      ),
    );
  }
}
