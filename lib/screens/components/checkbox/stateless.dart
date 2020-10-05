import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class RefashionedCheckboxStateless extends StatelessWidget {
  final bool value;
  final bool enabled;

  final double size;
  final EdgeInsets padding;
  final Function() onUpdate;

  const RefashionedCheckboxStateless({
    Key key,
    this.value: false,
    this.size,
    this.padding,
    this.onUpdate,
    this.enabled: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final safeSize = size ?? 20;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (enabled) onUpdate?.call();
      },
      child: GestureDetector(
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: !enabled
              ? Container(
                  height: safeSize,
                  width: safeSize,
                  decoration: ShapeDecoration(
                    color: Color(0xFFEAEAEA),
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFD3D3D3),
                      ),
                    ),
                  ),
                )
              : value
                  ? Container(
                      height: safeSize,
                      width: safeSize,
                      decoration: ShapeDecoration(
                        color: primaryColor,
                        shape: CircleBorder(),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(safeSize / 4),
                          child: SVGIcon(
                            icon: IconAsset.done,
                            color: accentColor,
                            size: 14,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: safeSize,
                      width: safeSize,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFBEBEBE),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
