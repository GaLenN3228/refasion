import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/components/bottom_button.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_title.dart';
import 'package:refashioned_app/screens/catalog/filters/filter_panel.dart';

class FiltersPanel extends StatelessWidget {
  final List<Filter> filters;

  const FiltersPanel({Key key, this.filters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Material(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FiltersTitle(),
              ]..addAll(filters.asMap().entries.map((filter) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (filter.key != 0) CategoryDivider(),
                      FilterTile(filter: filter.value),
                    ],
                  ))),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomButton(
            action: () => Navigator.of(context).pop(),
            title: "ПОКАЗАТЬ",
            subtitle: "5083 товара",
          ),
        )
      ],
    );
  }
}
