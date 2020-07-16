import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/catalog/filters/components/selectable_list.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_title.dart';

class FilterPanel extends StatelessWidget {
  final Filter original;
  final Filter modified;
  final Function(List<FilterValue>) onChange;

  const FilterPanel({Key key, this.original, this.onChange, this.modified})
      : super(key: key);

  bool checkIfModified(FilterValue filterValue) {
    if (modified != null) {
      // print(
      //     "Filter " + original.name + "\noriginal value " + filterValue.value);
      // print("Modified values " + modified.values.toString());
      // print("Contains: " + modified.values.contains(filterValue).toString());
    }

    return modified != null && modified.values.contains(filterValue);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: Colors.white,
          child: Column(
            children: [
              FiltersTitle(
                filter: original,
              ),
              Expanded(
                child: SelectableList(
                  initialData: Map.fromIterable(original.values,
                      key: (filterValue) => filterValue,
                      value: (filterValue) => checkIfModified(filterValue)),
                  onUpdate: (value) => onChange(value),
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
