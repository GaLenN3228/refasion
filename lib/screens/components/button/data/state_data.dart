import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

import 'decoration.dart';
import 'icon_data.dart';
import 'label_data.dart';

enum RBActivityIndicatorTheme { dark, light }

class RBStateData {
  final RBDecorationData decoration;

  final RBIconData leftIcon;

  final RBIconData icon;

  final RBLabelData label;

  final Function() onTap;

  bool animateTitleIn = true;
  bool animateTitleOut = true;
  bool animateCaptionIn = true;
  bool animateCaptionOut = true;
  bool animateIconIn = true;
  bool animateIconOut = true;

  RBStateData({
    this.decoration,
    this.leftIcon,
    this.icon,
    this.label,
    this.onTap,
  });

  factory RBStateData.simple({
    RBDecorationData decoration,
    RBLabelData label,
    RBIconData icon,
    Function onTap,
  }) {
    if (decoration == null || (label == null && icon == null)) return null;

    return RBStateData(
      decoration: decoration,
      label: label,
      icon: icon,
      onTap: onTap,
    );
  }

  factory RBStateData.enabled({
    String title,
    String caption,
    RBIconData icon,
    Function onTap,
    bool animate: true,
  }) {
    if (title == null && icon == null) return null;

    return RBStateData(
      decoration: RBDecorationData.ofStyle(
        RBDecoration.black,
      ),
      label: RBLabelData.ofTitle(
        title,
        caption: caption,
        color: white,
        titleAnimation: animate ? RBContentAnimation.fade : null,
        captionAnimation: animate ? RBContentAnimation.size : null,
      ),
      icon: icon,
      onTap: onTap,
    );
  }

  factory RBStateData.accent({
    String title,
    String caption,
    RBIconData icon,
    Function onTap,
    bool animate: true,
  }) {
    if (title == null && icon == null) return null;

    return RBStateData(
      decoration: RBDecorationData.ofStyle(
        RBDecoration.accent,
      ),
      label: RBLabelData.ofTitle(
        title,
        caption: caption,
        color: primaryColor,
        titleAnimation: animate ? RBContentAnimation.fade : null,
        captionAnimation: animate ? RBContentAnimation.size : null,
      ),
      icon: icon,
      onTap: onTap,
    );
  }

  factory RBStateData.outlined({
    String title,
    String caption,
    RBIconData icon,
    Function onTap,
    bool animate: true,
  }) {
    if (title == null && icon == null) return null;

    return RBStateData(
      decoration: RBDecorationData.ofStyle(
        RBDecoration.outlined,
      ),
      label: RBLabelData.ofTitle(
        title,
        caption: caption,
        color: primaryColor,
        titleAnimation: animate ? RBContentAnimation.fade : null,
        captionAnimation: animate ? RBContentAnimation.size : null,
      ),
      icon: icon,
      onTap: onTap,
    );
  }

  factory RBStateData.red({
    String title,
    String caption,
    RBIconData icon,
    Function onTap,
    bool animate: true,
  }) {
    if (title == null && icon == null) return null;

    return RBStateData(
      decoration: RBDecorationData.ofStyle(
        RBDecoration.red,
      ),
      label: RBLabelData.ofTitle(
        title,
        caption: caption,
        color: white,
        titleAnimation: animate ? RBContentAnimation.fade : null,
        captionAnimation: animate ? RBContentAnimation.size : null,
      ),
      icon: icon,
      onTap: onTap,
    );
  }

  factory RBStateData.disabled({
    String title,
    String caption,
    RBIconData icon,
    Function onTap,
    bool animate: true,
  }) {
    if (title == null && icon == null) return null;

    return RBStateData(
      decoration: RBDecorationData.ofStyle(
        RBDecoration.gray,
      ),
      label: RBLabelData.ofTitle(
        title,
        caption: caption,
        color: white,
        titleAnimation: animate ? RBContentAnimation.fade : null,
        captionAnimation: animate ? RBContentAnimation.size : null,
      ),
      icon: icon,
      onTap: onTap,
    );
  }

  factory RBStateData.loading({
    RBActivityIndicatorTheme theme,
    bool animate: true,
  }) {
    Widget indicator = SizedBox();

    switch (theme) {
      case RBActivityIndicatorTheme.dark:
        indicator = Theme(
          data: ThemeData(
            cupertinoOverrideTheme: CupertinoThemeData(
              brightness: Brightness.dark,
            ),
          ),
          child: CupertinoActivityIndicator(),
        );
        break;

      default:
        indicator = Theme(
          data: ThemeData(
            cupertinoOverrideTheme: CupertinoThemeData(
              brightness: Brightness.light,
            ),
          ),
          child: CupertinoActivityIndicator(),
        );
        break;
    }

    return RBStateData.disabled(
      icon: RBIconData(
        icon: SizedBox(
          width: 20,
          child: indicator,
        ),
        animation: animate ? RBIconAnimation.fade : null,
      ),
    );
  }
}
