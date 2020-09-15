import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

class RefashionedRadioButtonStateless extends StatelessWidget {
  final bool value;

  final double size;
  final EdgeInsets padding;

  const RefashionedRadioButtonStateless({
    Key key,
    this.value: false,
    this.size,
    this.padding: EdgeInsets.zero,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final boxSize = size ?? 20;

    return GestureDetector(
      child: Padding(
        padding: padding,
        child: Container(
          height: boxSize,
          width: boxSize,
          decoration: ShapeDecoration(
            shape: CircleBorder(
              side: BorderSide(
                color: primaryColor,
                width: 1,
              ),
            ),
          ),
          child: value
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(boxSize / 5),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: primaryColor,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
