import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashioned_app/utils/colors.dart';

enum ButtonIconAlign { left, right }

enum ButtonIconType { none, arrow_right_long }

enum ButtonIconColor { white, accent, black, darkGray }

class ButtonIconData {
  final ButtonIconType icon;
  final ButtonIconColor color;

  ButtonIconData({this.icon: ButtonIconType.none, this.color})
      : assert((icon != null && color != null) || icon == ButtonIconType.none);
}

class ButtonIcon extends StatelessWidget {
  final ButtonIconData currentData;
  final ButtonIconData nextData;

  final ButtonIconAlign align;

  final Animation<double> animation;

  const ButtonIcon(
      {this.currentData, this.nextData, this.animation, this.align})
      : assert(currentData != null && align != null);

  @override
  Widget build(BuildContext context) {
    if (currentData.icon == ButtonIconType.none) return SizedBox();

    EdgeInsets padding;
    Alignment alignment;

    switch (align) {
      case ButtonIconAlign.left:
        padding = const EdgeInsets.only(right: 10);
        alignment = Alignment.centerLeft;
        break;
      case ButtonIconAlign.right:
        padding = const EdgeInsets.only(left: 10);
        alignment = Alignment.centerRight;
        break;
    }

    String asset;

    switch (currentData.icon) {
      case ButtonIconType.arrow_right_long:
        asset = "assets/button/svg/long_arrow_right_21dp.svg";
        break;
      default:
        asset = "";
    }

    Color iconColor;

    switch (currentData.color) {
      case ButtonIconColor.white:
        iconColor = Colors.white;
        break;

      case ButtonIconColor.accent:
        iconColor = accentColor;
        break;

      case ButtonIconColor.darkGray:
        iconColor = darkGrayColor;
        break;

      default:
        iconColor = primaryColor;
        break;
    }

    return Container(
      alignment: alignment,
      padding: padding,
      child: SvgPicture.asset(
        asset,
        color: iconColor,
        width: 21,
        height: 11,
      ),
    );
  }
}
