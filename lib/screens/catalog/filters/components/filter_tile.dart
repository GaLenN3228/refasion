import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile_list.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile_range.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile_slider.dart';

enum FilterType { list, range, slider }

class FilterTile extends StatelessWidget {
  final Filter original;
  final Filter modified;
  final Function(Filter) onChange;

  const FilterTile({Key key, this.original, this.onChange, this.modified})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (original.type) {
      case "slider":
        return FilterTileSlider(
          original: original,
          modified: modified,
          onChange: onChange,
        );

      case "list":
        return FilterTileList(
          original: original,
          modified: modified,
          onChange: onChange,
        );

      case "range":
        return FilterTileRange(
          original: original,
          modified: modified,
          onChange: onChange,
        );

      default:
        return Text(original.type);
    }
  }
}
