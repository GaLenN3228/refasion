import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class RefashionedCheckboxStateless extends StatelessWidget {
  final bool value;

  final double size;
  final EdgeInsets padding;
  final Function() onUpdate;

  const RefashionedCheckboxStateless(
      {Key key,
      this.value: false,
      this.size: 20,
      this.padding: EdgeInsets.zero,
      this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onUpdate?.call,
      child: GestureDetector(
        child: Padding(
          padding: padding,
          child: value
              ? Container(
                  height: size,
                  width: size,
                  decoration: ShapeDecoration(
                      color: primaryColor, shape: CircleBorder()),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(size / 4),
                      child: SVGIcon(
                        icon: IconAsset.done,
                        color: accentColor,
                        size: 14,
                      ),
                    ),
                  ),
                )
              : Container(
                  height: size,
                  width: size,
                  decoration: ShapeDecoration(
                      shape: CircleBorder(
                          side: BorderSide(
                              width: 1, color: const Color(0xFFE6E6E6)))),
                ),
        ),
      ),
    );
  }
}
