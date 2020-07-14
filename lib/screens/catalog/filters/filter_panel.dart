import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/components/bottom_button.dart';
import 'package:refashioned_app/screens/catalog/components/selectable_list.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_title.dart';

class FilterPanel extends StatelessWidget {
  final Filter filter;

  const FilterPanel({Key key, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          child: Column(
            children: [
              FiltersTitle(
                filter: filter,
              ),
              Expanded(
                child: SelectableList(
                  initialData: Map.fromIterable(filter.values,
                      key: (value) => value, value: (_) => false),
                  onUpdate: (value) =>
                      print("Selected " + value.length.toString() + " values"),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomButton(
            action: () => Navigator.of(context).pop(),
            title: "ВЫБРАТЬ",
          ),
        )
      ],
    );
  }
}
