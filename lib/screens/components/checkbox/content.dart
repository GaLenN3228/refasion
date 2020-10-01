import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class CheckboxContent extends StatelessWidget {
  final bool value;
  final double size;

  const CheckboxContent({Key key, this.value, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxSize = size ?? 20;

    if (value)
      return Container(
        height: boxSize,
        width: boxSize,
        decoration: ShapeDecoration(
          color: primaryColor,
          shape: CircleBorder(),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(boxSize / 4),
            child: SVGIcon(
              icon: IconAsset.done,
              color: accentColor,
              size: 14,
            ),
          ),
        ),
      );

    return Container(
      height: boxSize,
      width: boxSize,
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFBEBEBE),
          ),
        ),
      ),
    );
  }
}
