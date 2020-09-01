import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/components/checkbox/checkbox.dart';
import '../../../../utils/colors.dart';

class TileOfSelectableList extends StatelessWidget {
  final double horizontalHeight;
  final double horizontalWidth;
  final double horizontalCornerRadius;
  final double horizontalBorderWidth;
  final double horizontalBorderColor;
  final bool horizontal;
  final FilterValue filterValue;
  final Function(String) onSelect;

  const TileOfSelectableList(
      {Key key,
      this.filterValue,
      this.onSelect,
      this.horizontalHeight: 30.0,
      this.horizontal: false,
      this.horizontalWidth: 35.0,
      this.horizontalCornerRadius: 5.0,
      this.horizontalBorderWidth: 1.0,
      this.horizontalBorderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onSelect(filterValue.id),
      child: horizontal
          ? Container(
              height: horizontalHeight,
              decoration: ShapeDecoration(
                  color: filterValue.selected ? accentColor : Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: horizontalBorderWidth,
                          color: filterValue.selected
                              ? accentColor
                              : horizontalBorderColor ?? Color(0xFFE6E6E6)),
                      borderRadius:
                          BorderRadius.circular(horizontalCornerRadius))),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    filterValue.value,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RefashionedCheckbox(
                    value: filterValue.selected,
                  ),
                  SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    child: Text(
                      filterValue.value,
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
