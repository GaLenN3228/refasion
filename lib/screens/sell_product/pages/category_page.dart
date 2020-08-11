import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/categories_list.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_bottom.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_button.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_middle.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class CategoryPage extends StatelessWidget {
  final Function(Category) onPush;
  final Function() onClose;
  final Category selectedTopCategory;
  final bool multiselection;

  CategoryPage(
      {Key key,
      this.onPush,
      this.selectedTopCategory,
      this.multiselection: false,
      this.onClose})
      : assert(selectedTopCategory != null);

  final isScrolled = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CategoriesList(
        categories: selectedTopCategory.children,
        bottomPadding: 10,
        isScrolled: isScrolled,
        onPush: onPush,
        appBar: TopBar(
          leftButtonType: TBButtonType.icon,
          leftButtonIcon: TBIconType.back,
          leftButtonAction: () => Navigator.of(context).pop(),
          middleType: TBMiddleType.text,
          middleText: "Добавить вещь",
          rightButtonType: TBButtonType.text,
          rightButtonText: "Закрыть",
          rightButtonAction: onClose,
          bottomType: TBBottomType.header,
          bootomHeaderText: "Выберите категорию",
          isElevated: isScrolled,
        ),
      ),
    );
  }
}
