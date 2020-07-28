import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/filters/components/selection_mark.dart';
import '../../../models/category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final Function(Category) onPush;
  final bool selected;

  const CategoryTile({Key key, this.category, this.onPush, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPush(category) ?? {},
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 50,
          alignment: Alignment.centerLeft,
          child: selected == null
              ? Text(
                  category.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w500),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SelectionMark(
                      selected: selected,
                    )
                  ],
                )),
    );
  }
}
