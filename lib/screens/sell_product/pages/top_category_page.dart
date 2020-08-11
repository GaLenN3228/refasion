import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_bottom.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_button.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_middle.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';
import 'package:refashioned_app/screens/sell_product/components/top_category_tile.dart';

class TopCategoryPage extends StatelessWidget {
  final Function() onClose;
  final Function(Category) onPush;
  final Category selectedSection;

  const TopCategoryPage({this.onPush, this.selectedSection, this.onClose})
      : assert(selectedSection != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          TopBar(
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
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: selectedSection.children
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
