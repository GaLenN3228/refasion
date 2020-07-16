import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/colors.dart';

class SelectionMark extends StatelessWidget {
  final bool selected;
  final double size;
  final Color selectedBackColor;
  final Color selectedIconColor;
  final Color deselectedBorderColor;

  const SelectionMark(
      {Key key,
      this.selected = false,
      this.size = 20.0,
      this.selectedBackColor = primaryColor,
      this.selectedIconColor = accentColor,
      this.deselectedBorderColor = const Color(0xFFE6E6E6)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (selected)
      return Container(
        height: size,
        width: size,
        decoration:
            ShapeDecoration(color: selectedBackColor, shape: CircleBorder()),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(size / 4),
            child: SvgPicture.asset(
              'assets/small_selected.svg',
              color: selectedIconColor,
            ),
          ),
        ),
      );

    return Container(
      height: size,
      width: size,
      decoration: ShapeDecoration(
          shape: CircleBorder(
              side: BorderSide(width: 1, color: deselectedBorderColor))),
    );
  }
}
