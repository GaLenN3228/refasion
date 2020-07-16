import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/selection_mark.dart';

import '../../../../utils/colors.dart';

class TileOfSelectableList extends StatelessWidget {
  final double horizontalHeight;
  final double horizontalWidth;
  final double horizontalCornerRadius;
  final double horizontalBorderWidth;
  final double horizontalBorderColor;
  final bool horizontal;
  final MapEntry<FilterValue, bool> data;
  final Function(FilterValue) onSelect;

  const TileOfSelectableList(
      {Key key,
      this.data,
      this.onSelect,
      this.horizontalHeight: 30.0,
      this.horizontal,
      this.horizontalWidth: 35.0,
      this.horizontalCornerRadius: 5.0,
      this.horizontalBorderWidth: 1.0,
      this.horizontalBorderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onSelect(data.key),
      child: horizontal
          ? Container(
              height: horizontalHeight,
              decoration: ShapeDecoration(
                  color: data.value ? primaryColor : Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: horizontalBorderWidth,
                          color: data.value
                              ? primaryColor
                              : horizontalBorderColor ?? Color(0xFFE6E6E6)),
                      borderRadius:
                          BorderRadius.circular(horizontalCornerRadius))),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    data.key.value,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: data.value ? accentColor : primaryColor),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SelectionMark(
                    selected: data.value,
                  ),
                  SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    child: Text(
                      data.key.value,
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
