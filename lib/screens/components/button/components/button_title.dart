import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

enum ButtonTitleColor { white, accent, black, darkGray }

class ButtonTitle extends StatelessWidget {
  final ButtonTitleColor type;

  final String text;
  final bool uppercase;

  const ButtonTitle({this.type, this.text, this.uppercase: true})
      : assert(type != null && text != null);

  @override
  Widget build(BuildContext context) {
    Color textColor;

    switch (type) {
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

    return Text(uppercase ? text.toUpperCase() : text,
        style: Theme.of(context).textTheme.button.copyWith(color: textColor));
  }
}
