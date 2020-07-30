import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/header.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';
import 'package:refashioned_app/screens/sell_product/components/top_category_tile.dart';

class TopCategoryPage extends StatelessWidget {
  final Function() onClose;
  final Function(Category) onPush;
  final Category selectedSection;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  const TopCategoryPage(
      {Key key,
      this.onPush,
      this.selectedSection,
      this.onClose,
      this.animation,
      this.secondaryAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          SellProductTopBar(),
          Expanded(
            child: Column(
              children: [
                Header(
                  text: "Выберите категорию",
                ),
                Expanded(
                  child: selectedSection != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: selectedSection.children
                              .map((section) => TopCategoryTile(
                                    topCategory: section,
                                    onPush: onPush,
                                  ))
                              .toList(),
                        )
                      : Center(
                          child: Text("Не выбрана секция"),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
