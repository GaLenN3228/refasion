import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/categories_list.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class SubcategoryPage extends StatelessWidget {
  final Function(List<Category>) onPush;
  final Function() onClose;
  final Category selectedCategory;
  final isScrolled = ValueNotifier<bool>(false);

  SubcategoryPage({this.onPush, this.selectedCategory, this.onClose})
      : assert(selectedCategory != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CategoriesList(
        categories: selectedCategory.children,
        bottomPadding: 65,
        multiselection: true,
        onUpdate: onPush,
        isScrolled: isScrolled,
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
