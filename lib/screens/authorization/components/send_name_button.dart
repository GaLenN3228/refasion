import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';

class SendCustomerNameButton extends StatefulWidget {
  final RBState state;

  final Function() onPush;

  const SendCustomerNameButton({Key key, this.onPush, this.state}) : super(key: key);

  @override
  _SendCustomerNameButtonState createState() => _SendCustomerNameButtonState();
}

class _SendCustomerNameButtonState extends State<SendCustomerNameButton> {
  RBData buttonData;

  @override
  void initState() {
    buttonData = RBData.map(
      initState: RBState.disabled,
      data: {
        RBState.enabled: RBStateData.enabled(
          title: "Завершить",
          onTap: () => widget.onPush?.call(),
        ),
        RBState.disabled: RBStateData.disabled(
          title: "Завершить",
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
  void didUpdateWidget(covariant SendCustomerNameButton oldWidget) {
    switch (widget.state) {
      case RBState.enabled:
        buttonData.setState(
          RBState.enabled,
          animateTitleIn: buttonData.state != RBState.disabled,
          animateTitleOut: buttonData.state != RBState.disabled,
        );

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
