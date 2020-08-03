import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/models/quick_filter.dart';
import 'package:refashioned_app/utils/colors.dart';

class QuickFilterItem extends StatelessWidget {
  final double horizontalHeight;
  final double horizontalWidth;
  final double horizontalCornerRadius;
  final double horizontalBorderWidth;
  final QuickFilter filterValue;
  final Function(String) onSelect;
  final bool isNavigationButton;

  const QuickFilterItem(
      {Key key,
      this.filterValue,
      this.onSelect,
      this.horizontalHeight: 30.0,
      this.horizontalWidth: 30.0,
      this.horizontalCornerRadius: 5.0,
      this.horizontalBorderWidth: 1.0,
      this.isNavigationButton: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onSelect(filterValue.urlParams),
        child: isNavigationButton
            ? Container(
                height: horizontalHeight,
                width: horizontalWidth,
                decoration: ShapeDecoration(
                    color: accentColor,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: horizontalBorderWidth, color: accentColor),
                        borderRadius: BorderRadius.circular(horizontalCornerRadius))),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  child: SvgPicture.asset(
                    'assets/navigation.svg',
                    color: Colors.black,
                    width: 44,
                    height: 44,
                  ),
                )),
              )
            : Container(
                height: horizontalHeight,
                decoration: ShapeDecoration(
                    color: filterValue.selected ? accentColor : Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: horizontalBorderWidth,
                            color: filterValue.selected ? accentColor : Color(0xFFE6E6E6)),
                        borderRadius: BorderRadius.circular(horizontalCornerRadius))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      filterValue.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w500, color: primaryColor),
                    ),
                  ),
                ),
              ));
  }
}
