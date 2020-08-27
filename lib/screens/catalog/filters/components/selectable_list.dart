import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/tile_of_selectable_list.dart';

class SelectableList extends StatelessWidget {
  final List<FilterValue> values;
  final Function(String) onSelect;
  final bool horizontal;
  final double horizontalHeight;
  final EdgeInsets padding;

  const SelectableList(
      {Key key,
      this.values,
      this.onSelect,
      this.horizontal: false,
      this.horizontalHeight: 30.0,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: horizontal ? horizontalHeight : 0.0,
      child: ListView.separated(
        scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
        itemCount: values.length,
        padding: padding ?? EdgeInsets.zero,
        itemBuilder: (context, index) {
          return TileOfSelectableList(
            horizontal: horizontal,
            horizontalHeight: horizontalHeight,
            filterValue: values.elementAt(index),
            onSelect: onSelect,
          );
        },
        separatorBuilder: (context, index) {
          if (horizontal)
            return SizedBox(
              width: 5,
            );
          else
            return ItemsDivider();
        },
      ),
    );
  }
}
