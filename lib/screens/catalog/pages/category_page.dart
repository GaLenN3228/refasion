import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/components/category_brands.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/components/category_image.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';
import '../../../models/category.dart';
import '../components/category_tile.dart';

enum CategoryLevel { categories, category }

class CategoryPage extends StatelessWidget {
  final Category topCategory;
  final CategoryLevel level;
  final Function(Category) onPush;
  final Function() onSearch;

  const CategoryPage(
      {Key key, this.topCategory, this.onPush, this.level, this.onSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgets = (level == CategoryLevel.category
        ? <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryImage(
                  category: topCategory,
                ),
                CategoryBrands()
              ],
            )
          ]
        : List<Widget>())
      ..addAll(topCategory.children
          .map(
            (category) => CategoryTile(
              category: category,
              onPush: onPush,
            ),
          )
          .toList());

    return CupertinoPageScaffold(
      child: Column(
        children: [
          TopPanel(
            canPop: true,
            onSearch: onSearch,
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
      ),
    );
  }
}
