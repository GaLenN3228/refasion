import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/components/content.dart';
import 'package:refashioned_app/screens/components/button/data/label_data.dart';
import 'package:refashioned_app/utils/colors.dart';

class RBCaption extends StatelessWidget {
  final RBLabelData data;
  final Animation<double> animation;
  final RBContentAnimationDirection direction;

  final bool animate;

  const RBCaption({Key key, this.data, this.animation, this.direction, this.animate}) : super(key: key);

  double factor(double value) {
    switch (direction) {
      case RBContentAnimationDirection.animationIn:
        return value;

      case RBContentAnimationDirection.animationOut:
        return 1.0 - value;

      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null || data.caption == null || data.color == null) return SizedBox();

    Widget content = Text(
      data.caption,
      style: Theme.of(context).textTheme.caption.copyWith(
            color: data.color ?? primaryColor,
            fontWeight: FontWeight.w300,
          ),
    );

    if (data.captionAnimation == null || !animate) return content;

    switch (data?.captionAnimation) {
      case RBContentAnimation.size:
        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) {
            final value = factor(animation.value);

            return ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: value,
                widthFactor: null,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              ),
            );
          },
          child: content,
        );

      default:
        return content;
    }
  }
}
