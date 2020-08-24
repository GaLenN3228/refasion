import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/sell_product/components/top_category_tile.dart';

class TopCategoryPage extends StatelessWidget {
  final Category section;

  final Function() onClose;
  final Function(Category) onPush;

  const TopCategoryPage({this.onPush, this.section, this.onClose})
      : assert(section != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.sellerPage(
              leftAction: () => Navigator.of(context).pop(),
              titleText: "Добавить вещь",
              rightAction: onClose,
              headerText: "Выберите категорию",
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: section.children
                  .map((section) => TopCategoryTile(
                        topCategory: section,
                        onPush: onPush,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
