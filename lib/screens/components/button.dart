import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/add_product/maps/add_address.dart';
import 'package:refashioned_app/utils/colors.dart';

enum ButtonStyle { dark, amber, outline, gray }

class Button extends StatelessWidget {
  final String textButton;
  final String subTitle;
  final ButtonStyle buttonStyle;
  final double width;
  final double height;
  final bool toUpperCase;
  final Function() onClick;

  final double borderRadius;

  const Button(this.textButton,
      {this.buttonStyle = ButtonStyle.amber,
        this.width = 100,
        this.height = 30,
        this.borderRadius = 3.0,
        this.subTitle,
        this.toUpperCase = true,
        this.onClick});

  Color _getBackgroundColor() {
    switch (buttonStyle) {
      case ButtonStyle.amber:
        return accentColor;
      case ButtonStyle.outline:
        return Colors.white;
      case ButtonStyle.gray:
        return Color(0xFFF5F5F5);
      case ButtonStyle.dark:
      default:
        return primaryColor;
    }
  }

  BoxDecoration _getShape() {
    switch (buttonStyle) {
      case ButtonStyle.outline:
        return BoxDecoration(
          color: _getBackgroundColor(),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(borderRadius),
        );
      case ButtonStyle.amber:
      case ButtonStyle.dark:
      default:
        return BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(borderRadius),
        );
    }
  }

  TextStyle _getTextStyle(TextStyle textStyle) {
    switch (buttonStyle) {
      case ButtonStyle.amber:
      case ButtonStyle.outline:
      case ButtonStyle.gray:
        return textStyle.copyWith(color: primaryColor);
      case ButtonStyle.dark:
      default:
        return textStyle.copyWith(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle buttonTextStyle = Theme
        .of(context)
        .textTheme
        .button;
    TextStyle captionTextStyle = Theme
        .of(context)
        .textTheme
        .caption;
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: () {
          onClick();
        },
        child: Container(
          padding: EdgeInsets.zero,
          decoration: _getShape(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(toUpperCase ? textButton.toUpperCase() : textButton,
                  style: _getTextStyle(buttonTextStyle)),
              subTitle != null
                  ? Text(subTitle, style: _getTextStyle(captionTextStyle))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
