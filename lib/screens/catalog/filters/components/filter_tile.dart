import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile_list.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile_range.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile_slider.dart';

enum FilterType { list, range, slider }

class FilterTile extends StatelessWidget {
  final Filter filter;
  final Function() onUpdate;
  final Function(String url, String title) openInfoWebViewBottomSheet;

  const FilterTile({Key key, this.filter, this.onUpdate, this.openInfoWebViewBottomSheet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (filter.type) {
      case "slider":
        return FilterTileSlider(
          filter: filter,
          onUpdate: onUpdate,
        );

      case "list":
        return FilterTileList(
          filter: filter,
          onUpdate: onUpdate,
        );

      case "range":
        return FilterTileRange(
          openInfoWebViewBottomSheet: openInfoWebViewBottomSheet,
          filter: filter,
          onUpdate: onUpdate,
        );

      default:
        return Text(filter.type);
    }
  }
}
