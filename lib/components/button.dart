import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

enum ButtonStyle { dark, amber, outline }

class Button extends StatelessWidget {
  final String textButton;
  final ButtonStyle buttonStyle;
  final double width;
  final double height;

  final double borderRadius;

  const Button(this.textButton,
      {this.buttonStyle = ButtonStyle.amber,
      this.width = 100,
      this.height = 30,
      this.borderRadius = 3.0});

  Color _getBackgroundColor() {
    switch (buttonStyle) {
      case ButtonStyle.amber:
        return accentColor;
      case ButtonStyle.outline:
        return Colors.white;
      case ButtonStyle.dark:
      default:
        return primaryColor;
    }
  }

  RoundedRectangleBorder _getShape() {
    switch (buttonStyle) {
      case ButtonStyle.outline:
        return RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(borderRadius),
        );
      case ButtonStyle.amber:
      case ButtonStyle.dark:
      default:
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    TextStyle buttonDefaultStyle = Theme.of(context).textTheme.button;
    switch (buttonStyle) {
      case ButtonStyle.amber:
      case ButtonStyle.outline:
        return buttonDefaultStyle.copyWith(color: primaryColor);
      case ButtonStyle.dark:
      default:
        return buttonDefaultStyle.copyWith(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: RaisedButton(
        padding: EdgeInsets.zero,
        color: _getBackgroundColor(),
        shape: _getShape(),
        onPressed: () {},
        child: Text(textButton.toUpperCase(), style: _getTextStyle(context)),
      ),
    );
  }
}
