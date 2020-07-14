import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile_list.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile_range.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile_slider.dart';

enum FilterType { list, range, slider }

class FilterTile extends StatelessWidget {
  final Filter filter;

  const FilterTile({Key key, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (filter.type) {
      case "slider":
        return FilterTileSlider(
          filter: filter,
          onChange: (value) => print(value),
        );

      case "list":
        return FilterTileList(
          filter: filter,
        );

      case "range":
        return FilterTileRange(
          filter: filter,
        );

      default:
        return Text(filter.type);
    }
  }
}
