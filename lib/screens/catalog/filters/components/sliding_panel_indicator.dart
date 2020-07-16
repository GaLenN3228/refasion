import 'package:flutter/material.dart';

class SlidingPanelIndicator extends StatelessWidget {
  final double width;
  final double height;
  final double cornerRadius;
  final double topPadding;
  final double bottomPadding;
  final Color color;

  const SlidingPanelIndicator(
      {Key key,
      this.width: 30.0,
      this.height: 3.0,
      this.cornerRadius: 3.0,
      this.topPadding: 13.0,
      this.bottomPadding: 0.0,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
            color: color ?? Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cornerRadius))),
      ),
    );
  }
}
