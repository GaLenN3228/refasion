import 'package:flutter/material.dart';

enum RBIconAnimation { fade }

class RBIconData {
  final Widget icon;
  final RBIconAnimation animation;

  const RBIconData({
    this.icon,
    this.animation,
  });
}
