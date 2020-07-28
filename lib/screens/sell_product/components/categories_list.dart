import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import '../../../models/category.dart';
import '../../catalog/components/category_tile.dart';

class CategoriesList extends StatefulWidget {
  final Widget header;
  final Widget appBar;
  final List<Category> categories;
  final Function(Category) onPush;
  final Function(List<String>) onUpdate;
  final bool multiselection;
  final double bottomPadding;
  final ValueNotifier<bool> isScrolled;

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  const CategoriesList({
    Key key,
    this.onPush,
    this.onUpdate,
    this.multiselection: false,
    this.bottomPadding: 0.0,
    this.categories,
    this.header,
    this.appBar,
    this.isScrolled,
    this.animation,
    this.secondaryAnimation,
  }) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  List<String> selectedSubcategories;
  ScrollController scrollController;

  scrollListener() {
    if (widget.isScrolled != null)
      widget.isScrolled.value =
          scrollController.offset > scrollController.position.minScrollExtent;
  }

  @override
  void initState() {
    selectedSubcategories = List<String>();
    scrollController = ScrollController();

    scrollController.addListener(scrollListener);

    super.initState();
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();

    super.dispose();
  }

  update(String id) {
    final index = selectedSubcategories.indexOf(id);

    setState(() {
      if (index >= 0)
        selectedSubcategories.removeAt(index);
      else
        selectedSubcategories.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final widgets = widget.categories
        .map((category) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => widget.onPush(category),
              child: CategoryTile(
                  category: category,
                  selected: widget.multiselection
                      ? selectedSubcategories.contains(category.id)
                      : null,
                  onPush: (category) {
                    if (widget.multiselection)
                      update(category.id);
                    else if (widget.onPush != null) widget.onPush(category);
                  }),
            ))
        .toList();

    return Column(
      children: [
        widget.appBar ?? SizedBox(),
        Expanded(
          child: Column(
            children: [
              widget.header != null ? widget.header : SizedBox(),
              Expanded(
                child: Stack(
                  children: [
                    ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.only(
                          top: widget.header != null ? 11 : 0,
                          bottom: MediaQuery.of(context).padding.bottom +
                              widget.bottomPadding),
                      itemCount: widgets.length,
                      itemBuilder: (context, index) =>
                          widgets.elementAt(index),
                      separatorBuilder: (context, index) => CategoryDivider(),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: widget.multiselection
                          ? BottomButton(
                              title: "ВЫБРАТЬ",
                              action: () =>
                                  widget.onUpdate(selectedSubcategories),
                            )
                          : SizedBox(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
