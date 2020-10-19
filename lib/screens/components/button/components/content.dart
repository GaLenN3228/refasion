import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/components/caption.dart';
import 'package:refashioned_app/screens/components/button/components/icon.dart';
import 'package:refashioned_app/screens/components/button/components/title.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';

enum RBContentAnimationDirection { animationIn, animationOut }

class RBContent extends StatelessWidget {
  final RBStateData data;
  final Animation<double> animation;
  final RBContentAnimationDirection direction;

  final bool animateTitle;
  final bool animateCaption;
  final bool animateIcon;

  const RBContent({
    Key key,
    this.data,
    this.animation,
    this.direction,
    this.animateTitle,
    this.animateCaption,
    this.animateIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data?.label == null && data?.icon == null) return SizedBox();

    Widget content = SizedBox();

    if (data?.label != null && data?.icon != null)
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RBTitle(
                  data: data.label,
                  animation: animation,
                  direction: direction,
                  animate: animateTitle,
                ),
                RBCaption(
                  data: data.label,
                  animation: animation,
                  direction: direction,
                  animate: animateCaption,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: RBIcon(
              data: data.icon,
              animation: animation,
              direction: direction,
              animate: animateIcon,
            ),
          ),
        ],
      );
    else if (data?.label != null) {
      content = IntrinsicWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RBTitle(
              data: data.label,
              animation: animation,
              direction: direction,
              animate: animateTitle,
            ),
            RBCaption(
              data: data.label,
              animation: animation,
              direction: direction,
              animate: animateCaption,
            ),
          ],
        ),
      );
    } else
      content = RBIcon(
        data: data.icon,
        animation: animation,
        direction: direction,
        animate: animateIcon,
      );

    return content;
  }
}
