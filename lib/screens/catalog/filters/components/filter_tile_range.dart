import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/selectable_list.dart';

class FilterTileRange extends StatelessWidget {
  final Filter original;
  final Filter modified;
  final Function(Filter) onChange;

  const FilterTileRange({Key key, this.original, this.onChange, this.modified})
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
    return Padding(
      padding: const EdgeInsets.only(top: 23, bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              original.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 17,
          ),
          SelectableList(
            horizontal: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            initialData: Map.fromIterable(original.values,
                key: (filterValue) => filterValue,
                value: (filterValue) => checkIfModified(filterValue)),
            onUpdate: (value) {
              final newFilter = Filter(
                  name: original.name,
                  parameterName: original.parameterName,
                  type: original.type,
                  values: value);
              onChange(newFilter);
            },
          ),
        ],
      ),
    );
  }
}
