import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/components/checkbox/checkbox.dart';

class CategoryFilterItem extends StatelessWidget {
  final Category category;
  final Function(String) onSelect;

  const CategoryFilterItem({Key key, this.category, this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onSelect(category.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RefashionedCheckbox(
              value: category.selected,
              onUpdate: (value) {
                onSelect(category.id);
              },
            ),
            SizedBox(
              width: 11,
            ),
            Expanded(
              child: Text(
                category.name,
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
