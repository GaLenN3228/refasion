import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

enum ButtonTitleColor { white, accent, black, darkGray }

class ButtonTitleData {
  final ButtonTitleColor color;

  final String text;
  final bool uppercase;

  const ButtonTitleData({this.color, this.text, this.uppercase: true})
      : assert(color != null && text != null);
}

class ButtonTitle extends StatelessWidget {
  final ButtonTitleData currentData;
  final ButtonTitleData nextData;

  final Animation<double> animation;

  const ButtonTitle({this.currentData, this.nextData, this.animation})
      : assert(currentData != null);

  @override
  Widget build(BuildContext context) {
    Color textColor;

    switch (currentData.color) {
      case ButtonTitleColor.darkGray:
        textColor = darkGrayColor;
        break;

      case ButtonTitleColor.accent:
        textColor = accentColor;
        break;

      case ButtonTitleColor.white:
        textColor = Colors.white;
        break;

      default:
        textColor = primaryColor;
        break;
    }

    return Text(
        currentData.uppercase
            ? currentData.text.toUpperCase()
            : currentData.text,
        style: Theme.of(context).textTheme.button.copyWith(color: textColor));
  }
}
