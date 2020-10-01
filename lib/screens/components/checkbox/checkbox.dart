import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class RefashionedCheckbox extends StatefulWidget {
  final bool value;

  final double size;
  final EdgeInsets padding;
  final Function(bool) onUpdate;

  const RefashionedCheckbox({Key key, this.value: false, this.size, this.padding: EdgeInsets.zero, this.onUpdate})
      : super(key: key);

  @override
  _RefashionedCheckboxState createState() => _RefashionedCheckboxState();
}

class _RefashionedCheckboxState extends State<RefashionedCheckbox> {
  bool value;

  update() {
    widget.onUpdate?.call(!value);
    setState(() => value = !value);
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    value = widget.value;

    final boxSize = widget.size ?? 20;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: update,
      child: GestureDetector(
        child: Padding(
          padding: widget.padding,
          child: value
              ? Container(
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
                )
              : Container(
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
                ),
        ),
      ),
    );
  }
}
