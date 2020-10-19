import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/components/content.dart';
import 'package:refashioned_app/screens/components/button/data/icon_data.dart';

class RBIcon extends StatelessWidget {
  final RBIconData data;
  final Animation animation;
  final RBContentAnimationDirection direction;

  final bool animate;

  const RBIcon({
    Key key,
    this.data,
    this.animation,
    this.direction,
    this.animate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null || data.icon == null) return SizedBox();

    if (data.animation == null || !animate) return data.icon;

    switch (data?.animation) {
      case RBIconAnimation.fade:
        Tween<double> tween = Tween(begin: 0.0, end: 0.0);

        switch (direction) {
          case RBContentAnimationDirection.animationIn:
            tween = Tween(begin: 0.0, end: 1.0);
            break;
          case RBContentAnimationDirection.animationOut:
            tween = Tween(begin: 1.0, end: 0.0);
            break;
        }

        return FadeTransition(
          opacity: tween.animate(animation),
          child: data.icon,
        );

      default:
        return data.icon;
    }
  }
}
