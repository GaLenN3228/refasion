import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/categories_list.dart';
import 'package:refashioned_app/screens/sell_product/components/header.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class SubcategoryPage extends StatelessWidget {
  final Function(List<Category>) onPush;
  final Category selectedCategory;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final isScrolled = ValueNotifier<bool>(false);

  SubcategoryPage(
      {Key key,
      this.onPush,
      this.selectedCategory,
      this.animation,
      this.secondaryAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: selectedCategory != null
          ? CategoriesList(
              categories: selectedCategory.children,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              bottomPadding: 65,
              appBar: SellProductTopBar(),
              isScrolled: isScrolled,
              header: Header(
                text: "Выберите категорию",
                isScrolled: isScrolled,
              ),
              multiselection: true,
              onUpdate: onPush,
            )
          : Center(
              child: Text("Не выбрана категория"),
            ),
    );
  }
}
