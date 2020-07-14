import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/components/selectable_list.dart';

class FilterTileRange extends StatelessWidget {
  final Filter filter;

  const FilterTileRange({Key key, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              filter.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SelectableList(
            horizontal: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            initialData: Map.fromIterable(filter.values,
                key: (value) => value, value: (_) => false),
            onUpdate: (value) =>
                print("Selected " + value.length.toString() + " values"),
          ),
        ],
      ),
    );
  }
}
