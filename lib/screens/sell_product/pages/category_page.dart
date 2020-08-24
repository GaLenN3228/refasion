import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/sell_product/components/categories_list.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class CategoryPage extends StatelessWidget {
  final Category topCategory;

  final Function() onClose;
  final Function(Category) onPush;

  final bool multiselection;

  CategoryPage(
      {Key key,
      this.onPush,
      this.topCategory,
      this.multiselection: false,
      this.onClose})
      : assert(topCategory != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: CategoriesList(
        categories: topCategory.children,
        bottomPadding: 10,
        onPush: onPush,
        appBar: RefashionedTopBar(
          data: TopBarData.sellerPage(
            leftAction: () => Navigator.of(context).pop(),
            titleText: "Добавить вещь",
            rightAction: onClose,
            headerText: "Выберите категорию",
          ),
        ),
      ),
    );
  }
}
