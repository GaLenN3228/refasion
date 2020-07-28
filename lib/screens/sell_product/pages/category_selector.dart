import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/categories_list.dart';
import 'package:refashioned_app/screens/sell_product/components/header.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class CategorySelector extends StatelessWidget {
  final Function(Category) onPush;
  final Category selectedTopCategory;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  CategorySelector(
      {Key key,
      this.onPush,
      this.selectedTopCategory,
      this.animation,
      this.secondaryAnimation})
      : super(key: key);

  final isScrolled = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: selectedTopCategory != null
            ? CategoriesList(
                categories: selectedTopCategory.children,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                bottomPadding: 10,
                isScrolled: isScrolled,
                appBar: SellProductTopBar(),
                header: Header(
                  text: "Выберите категорию",
                  isScrolled: isScrolled,
                ),
                onPush: onPush,
              )
            : Center(
                child: Text("Не выбрана категория"),
              ));
  }
}
