import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/marketplace/components/categories_list.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class SubcategoryPage extends StatelessWidget {
  final Category initialData;
  final Category topCategory;

  final Function() onClose;
  final Function() onUpdate;
  final Function(Category) onPush;

  SubcategoryPage({this.onPush, this.topCategory, this.onClose, this.onUpdate, this.initialData})
      : assert(topCategory != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: CategoriesList(
        categories: topCategory.children,
        bottomPadding: 100,
        multiselection: true,
        onUpdate: (categories) => onPush(categories.last),
        appBar: RefashionedTopBar(
          data: TopBarData.simple(
            onBack: () => Navigator.of(context).pop(),
            middleText: "Добавить вещь",
            onClose: onClose,
            bottomText: "Выберите категорию",
          ),
        ),
      ),
    );
  }
}
