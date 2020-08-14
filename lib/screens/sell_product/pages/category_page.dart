import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/categories_list.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class CategoryPage extends StatefulWidget {
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

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CategoriesList(
        categories: widget.selectedTopCategory.children,
        bottomPadding: 10,
        scrollController: scrollController,
        onPush: widget.onPush,
        appBar: RefashionedTopBar(
          leftButtonType: TBButtonType.icon,
          leftButtonIcon: TBIconType.back,
          leftButtonAction: () => Navigator.of(context).pop(),
          middleType: TBMiddleType.title,
          middleTitleText: "Добавить вещь",
          rightButtonType: TBButtonType.text,
          rightButtonText: "Закрыть",
          rightButtonAction: widget.onClose,
          bottomType: TBBottomType.header,
          bootomHeaderText: "Выберите категорию",
          scrollController: scrollController,
        ),
      ),
    );
  }
}
