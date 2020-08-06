import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/products/components/category_filter_item.dart';

class CategoryFilterList extends StatelessWidget {
  final List<Category> values;
  final Function(String) onSelect;

  const CategoryFilterList({Key key, this.values, this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.0,
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: 60),
        scrollDirection: Axis.vertical,
        itemCount: values.length,
        itemBuilder: (context, index) {
          return CategoryFilterItem(
            category: values.elementAt(index),
            onSelect: onSelect,
          );
        },
        separatorBuilder: (context, index) {
          return CategoryDivider();
        },
      ),
    );
  }
}
