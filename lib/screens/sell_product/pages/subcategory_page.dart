import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/categories_list.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class SubcategoryPage extends StatefulWidget {
  final Function(List<Category>) onPush;
  final Function() onClose;
  final Category selectedCategory;

  SubcategoryPage({this.onPush, this.selectedCategory, this.onClose})
      : assert(selectedCategory != null);

  @override
  _SubcategoryPageState createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
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
        categories: widget.selectedCategory.children,
        bottomPadding: 65,
        multiselection: true,
        onUpdate: widget.onPush,
        scrollController: scrollController,
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
