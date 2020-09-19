import 'package:flutter/material.dart';
import 'package:refashioned_app/models/sort.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/catalog/sorting/components/sorting_method_tile.dart';
import 'package:refashioned_app/screens/catalog/sorting/components/sorting_title.dart';

class SortingPanel extends StatelessWidget {
  final Sort sort;
  final Function() onUpdate;

  const SortingPanel(this.sort, this.onUpdate);

  onSelect(String value) {
    if (sort != null) {
      sort.update(value);
      if (onUpdate != null) onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SortingTitle(),
          ]..addAll(sort.methods.asMap().entries.map((entry) => Column(
                children: [
                  if (entry.key != 0) ItemsDivider(),
                  SortMethodTile(entry.value, () {
                    onSelect(entry.value.value);
                    Navigator.of(context).pop();
                  })
                ],
              ))),
        ),
      ),
    );
  }
}
