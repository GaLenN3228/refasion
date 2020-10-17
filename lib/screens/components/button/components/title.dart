import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/components/content.dart';
import 'package:refashioned_app/screens/components/button/data/label_data.dart';
import 'package:refashioned_app/utils/colors.dart';

class RBTitle extends StatelessWidget {
  final RBLabelData data;
  final Animation animation;
  final RBContentAnimationDirection direction;

  final bool animate;

  const RBTitle({Key key, this.data, this.animation, this.direction, this.animate}) : super(key: key);

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
    if (data == null || data.title == null || data.color == null) return SizedBox();

    Widget content = Text(
      data.uppercase ? data.title.toUpperCase() : data.title,
      style: Theme.of(context).textTheme.button.copyWith(
            color: data.color ?? primaryColor,
          ),
    );

    if (data.titleAnimation == null || !animate) return content;

    switch (data?.titleAnimation) {
      case RBContentAnimation.fade:
        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) {
            final value = factor(animation.value);

            return Opacity(
              opacity: value,
              child: content,
            );
          },
        );

      case RBContentAnimation.typing:
        final startLength = data?.initialTitle?.length ?? 0;
        final endLength = data?.title?.length ?? 0;

        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) {
            final value = factor(animation.value);

            final length = (value * (endLength - startLength)).round();

            final text = data.title.substring(0, startLength + length);

            return ClipRect(
              child: Align(
                alignment: Alignment.center,
                widthFactor: value,
                child: Text(
                  data.uppercase ? text.toUpperCase() : text,
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: data.color ?? primaryColor,
                      ),
                ),
              ),
            );
          },
        );

      default:
        return content;
    }
  }
}
