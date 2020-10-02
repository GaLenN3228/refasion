import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

enum CustomButtonStyle { dark, amber, outline, gray, dark_gray }

class Button extends StatelessWidget {
  final String textButton;
  final String subTitle;
  final CustomButtonStyle buttonStyle;
  final double width;
  final double height;
  final bool toUpperCase;
  final Function() onClick;

  final double borderRadius;

  const Button(this.textButton,
      {this.buttonStyle = CustomButtonStyle.amber,
      this.width = 100,
      this.height = 30,
      this.borderRadius = 3.0,
      this.subTitle,
      this.toUpperCase = true,
      this.onClick});

  Color _getBackgroundColor() {
    switch (buttonStyle) {
      case CustomButtonStyle.amber:
        return accentColor;
      case CustomButtonStyle.outline:
        return Colors.white;
      case CustomButtonStyle.gray:
        return Color(0xFFF5F5F5);
      case CustomButtonStyle.dark_gray:
        return Colors.grey;
      case CustomButtonStyle.dark:
      default:
        return primaryColor;
    }
  }

  BoxDecoration _getShape() {
    switch (buttonStyle) {
      case CustomButtonStyle.outline:
        return BoxDecoration(
          color: _getBackgroundColor(),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(borderRadius),
        );
      case CustomButtonStyle.amber:
      case CustomButtonStyle.dark:
      default:
        return BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(borderRadius),
        );
    }
  }

  TextStyle _getTextStyle(TextStyle textStyle) {
    switch (buttonStyle) {
      case CustomButtonStyle.amber:
      case CustomButtonStyle.outline:
      case CustomButtonStyle.gray:
        return textStyle.copyWith(color: primaryColor);
      case CustomButtonStyle.dark:
      default:
        return textStyle.copyWith(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle buttonTextStyle = Theme.of(context).textTheme.button;
    TextStyle captionTextStyle = Theme.of(context).textTheme.caption;
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
              Text(toUpperCase ? textButton.toUpperCase() : textButton, style: _getTextStyle(buttonTextStyle)),
              subTitle != null ? Text(subTitle, style: _getTextStyle(captionTextStyle)) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
