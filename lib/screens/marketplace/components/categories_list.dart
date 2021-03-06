import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/category.dart' as RefCategory;
import 'package:refashioned_app/screens/catalog/components/category_tile.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:flutter/foundation.dart';

class CategoriesList extends StatefulWidget {
  final Widget header;
  final Widget appBar;
  final List<RefCategory.Category> categories;
  final Function(RefCategory.Category) onPush;
  final Function(List<RefCategory.Category>) onUpdate;
  final bool multiselection;
  final double bottomPadding;
  final ScrollController scrollController;

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
    this.scrollController,
    this.animation,
    this.secondaryAnimation,
  }) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  List<RefCategory.Category> selectedSubcategories;

  @override
  void initState() {
    selectedSubcategories = List<RefCategory.Category>();

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  update(RefCategory.Category category) {
    final index = selectedSubcategories.indexOf(category);

    setState(() {
      if (index >= 0)
        selectedSubcategories.removeAt(index);
      else
        selectedSubcategories.add(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final widgets = widget.categories
        .map((category) => CategoryTile(
            category: category,
            selected: widget.multiselection ? selectedSubcategories.contains(category) : null,
            onPush: () {
              if (widget.multiselection) {
                HapticFeedback.selectionClick();

                update(category);
              } else if (widget.onPush != null) widget.onPush(category);
            }))
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
                      controller: widget.scrollController ?? ScrollController(),
                      padding: EdgeInsets.only(
                          top: widget.header != null ? 11 : 0,
                          bottom: MediaQuery.of(context).padding.bottom + widget.bottomPadding),
                      itemCount: widgets.length,
                      itemBuilder: (context, index) => widgets.elementAt(index),
                      separatorBuilder: (context, index) => ItemsDivider(),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: widget.multiselection
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 10,
                                  bottom: defaultTargetPlatform == TargetPlatform.iOS ? 32 : 20),
                              child: Button(
                                "ВЫБРАТЬ",
                                buttonStyle: selectedSubcategories.isNotEmpty
                                    ? CustomButtonStyle.dark
                                    : CustomButtonStyle.dark_gray,
                                height: 45,
                                width: double.infinity,
                                borderRadius: 5,
                                onClick: selectedSubcategories.isNotEmpty
                                    ? () {
                                        widget.onUpdate(selectedSubcategories);
                                      }
                                    : () {},
                              ))
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
