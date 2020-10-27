import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

class RatingSelector extends StatelessWidget {
  final double starSize;
  final EdgeInsets padding;
  final int selected;
  final Function(int) onSelect;

  const RatingSelector({
    this.selected,
    this.padding,
    this.starSize,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        5,
        (index) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => onSelect?.call(index),
          child: Icon(
            Icons.star,
            size: starSize ?? 20,
            color: index <= (selected ?? -1) ? accentColor : Color(0xFFEAEAEA),
          ),
        ),
      ),
    );
  }
}
