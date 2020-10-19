import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/button/data/decoration.dart';
import 'package:refashioned_app/screens/components/button/data/label_data.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';
import 'package:refashioned_app/utils/colors.dart';

class SimpleButton extends StatefulWidget {
  final bool enabled;
  final String label;
  final Function() onPush;

  final EdgeInsets padding;
  final double height;

  const SimpleButton({Key key, this.enabled, this.label, this.onPush, this.padding, this.height}) : super(key: key);

  @override
  _SimpleButtonState createState() => _SimpleButtonState();
}

class _SimpleButtonState extends State<SimpleButton> {
  RBData buttonData;

  @override
  void initState() {
    buttonData = RBData.map(
      height: widget.height ?? 45,
      initState: widget.enabled ? RBState.enabled : RBState.disabled,
      data: {
        RBState.enabled: RBStateData.simple(
          decoration: RBDecorationData.ofStyle(RBDecoration.black),
          label: RBLabelData.ofTitle(widget.label, color: white),
          onTap: widget.onPush?.call,
        ),
        RBState.disabled: RBStateData.simple(
          decoration: RBDecorationData.ofStyle(RBDecoration.gray),
          label: RBLabelData.ofTitle(widget.label, color: white),
        ),
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
  void didUpdateWidget(covariant SimpleButton oldWidget) {
    if (widget.enabled)
      buttonData.setState(RBState.enabled);
    else
      buttonData.setState(RBState.disabled);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => RefashionedButton(
        padding: widget.padding,
        data: buttonData,
      );
}
