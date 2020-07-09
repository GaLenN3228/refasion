import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/components/category_brands.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/components/category_image.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';
import '../../../models/category.dart';
import '../components/category_tile.dart';

enum CategoryLevel { categories, category }

class CategoryPage extends StatelessWidget {
  final Category category;
  final CategoryLevel level;
  final Function(Category) onPush;

  final bool canPop;
  final Function() onPop;

  const CategoryPage(
      {Key key,
      this.category,
      this.onPush,
      this.level,
      this.canPop,
      this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgets = List<Widget>();

    if (level == CategoryLevel.category)
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryImage(
            category: category,
          ),
          CategoryBrands()
        ],
      ));

    widgets.addAll(category.children
        .map((category) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onPush(category),
              child: CategoryTile(
                category: category,
                uppercase: level != CategoryLevel.category,
              ),
            ))
        .toList());

    return Column(
      children: [
        TopPanel(
          canPop: canPop,
          onPop: onPop,
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(bottom: 89),
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              return widgets.elementAt(index);
            },
            separatorBuilder: (context, index) {
              return CategoryDivider();
            },
          ),
        ),
      ],
    );
  }
}
