import 'package:flutter/material.dart';

class TBMiddleData {
  final String titleText;
  final String subtitleText;

  final Widget child;

  const TBMiddleData({
    this.child,
    this.titleText,
    this.subtitleText,
  });

  factory TBMiddleData.title(String text) => text != null ? TBMiddleData(titleText: text) : null;

  factory TBMiddleData.custom(Widget child) => child != null ? TBMiddleData(child: child) : null;

  factory TBMiddleData.condensed(String title, String subtitle) =>
      title != null && subtitle != null ? TBMiddleData(titleText: title, subtitleText: subtitle) : null;
}
