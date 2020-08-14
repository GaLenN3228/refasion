import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_icon.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';

class ButtonData {
  final String titleText;
  final ButtonTitleColor titleColor;

  final ButtonIconType leftIcon;
  final ButtonIconColor leftIconColor;

  final ButtonIconType rightIcon;
  final ButtonIconColor rightIconColor;

  final ButtonDecorationType decorationType;

  ButtonData(
      {this.titleText,
      this.titleColor,
      this.leftIcon: ButtonIconType.none,
      this.leftIconColor,
      this.rightIcon: ButtonIconType.none,
      this.rightIconColor,
      this.decorationType})
      : assert(decorationType != null &&
            titleText != null &&
            leftIcon != null &&
            rightIcon != null);
}

enum ButtonState { enabled, loading, done, error }

class RefashionedButton extends StatefulWidget {
  final ButtonData data;

  final ValueNotifier<ButtonState> states;
  final Map<ButtonState, ButtonData> statesData;

  final Function() onTap;

  const RefashionedButton({
    this.states,
    this.data,
    this.statesData,
    this.onTap,
  }) : assert(data != null || (statesData != null && states != null));

  @override
  _RefashionedButtonState createState() => _RefashionedButtonState();
}

class _RefashionedButtonState extends State<RefashionedButton> {
  ButtonData data;

  ValueNotifier<ButtonContainerData> statesContainerData;

  @override
  initState() {
    data = widget.states != null && widget.statesData != null
        ? widget.statesData[widget.states.value]
        : widget.data;

    widget.states?.addListener(buttonStateListener);

    statesContainerData =
        ValueNotifier(ButtonContainerData(decorationType: data.decorationType));

    super.initState();
  }

  buttonStateListener() {
    setState(
        () => data = widget.statesData[widget.states.value] ?? widget.data);

    statesContainerData.value =
        ButtonContainerData(decorationType: data.decorationType);
  }

  @override
  dispose() {
    widget.states?.removeListener(buttonStateListener);

    statesContainerData.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap ?? () {},
      child: ButtonContainer(
        statesData: statesContainerData,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ButtonIcon(
              icon: data.leftIcon,
              align: ButtonIconAlign.left,
              color: data.leftIconColor,
            ),
            ButtonTitle(
              text: data.titleText,
              type: data.titleColor,
            ),
            ButtonIcon(
              icon: data.rightIcon,
              align: ButtonIconAlign.right,
              color: data.rightIconColor,
            ),
          ],
        ),
      ),
    );
  }
}
