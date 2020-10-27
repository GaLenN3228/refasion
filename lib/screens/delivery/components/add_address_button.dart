import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';

class AddAddressButton extends StatefulWidget {
  final RBState state;
  final Function() onPush;

  const AddAddressButton({Key key, this.onPush, this.state}) : super(key: key);

  @override
  _AddAddressButtonState createState() => _AddAddressButtonState();
}

class _AddAddressButtonState extends State<AddAddressButton> {
  RBData buttonData;

  @override
  void initState() {
    buttonData = RBData.map(
      initState: widget.state ?? RBState.disabled,
      data: {
        RBState.enabled: RBStateData.enabled(
          title: "Продолжить",
          onTap: () => widget.onPush?.call(),
        ),
        RBState.disabled: RBStateData.disabled(
          title: "Продолжить",
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
  void didUpdateWidget(covariant AddAddressButton oldWidget) {
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
