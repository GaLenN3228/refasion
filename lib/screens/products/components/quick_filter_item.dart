import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/quick_filter.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/products/pages/category_filter_panel.dart';
import 'package:refashioned_app/utils/colors.dart';

class QuickFilterItem extends StatelessWidget {
  final double horizontalHeight;
  final double horizontalWidth;
  final double horizontalCornerRadius;
  final double horizontalBorderWidth;
  final QuickFilter filterValue;
  final Function(String, List<int>) onSelect;
  final bool isNavigationButton;
  final Function() updateProducts;
  final List<Category> categories;
  final Category topCategory;

  const QuickFilterItem(
      {Key key,
      this.filterValue,
      this.onSelect,
      this.horizontalHeight: 30.0,
      this.horizontalWidth: 30.0,
      this.horizontalCornerRadius: 5.0,
      this.horizontalBorderWidth: 1.0,
      this.isNavigationButton: false,
      this.updateProducts,
      this.topCategory,
      this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => filterValue.values.id != null
            ? onSelect(filterValue.values.id, null)
            : onSelect(null, filterValue.values.price),
        child: isNavigationButton
            ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => showCupertinoModalBottomSheet(
                    backgroundColor: Colors.white,
                    expand: true,
                    context: context,
                    useRootNavigator: true,
                    builder: (context, controller) => CategoryFilterPanel(
                        topCategory: topCategory,
                        updateProducts: updateProducts,
                        categories: categories)),
                child: Container(
                  height: horizontalHeight,
                  width: horizontalWidth,
                  decoration: ShapeDecoration(
                      color: categories.where((element) => element.selected).isNotEmpty ? accentColor : Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: horizontalBorderWidth,
                              color: categories.where((element) => element.selected).isNotEmpty ? accentColor : Color(0xFFE6E6E6)),
                          borderRadius: BorderRadius.circular(horizontalCornerRadius))),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: SVGIcon(
                      icon: IconAsset.categories,
                      size: 22,
                    ),
                  )),
                ))
            : Container(
                height: horizontalHeight,
                decoration: ShapeDecoration(
                    color: filterValue.selected ? accentColor : Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: horizontalBorderWidth,
                            color: filterValue.selected ? accentColor : Color(0xFFE6E6E6)),
                        borderRadius: BorderRadius.circular(horizontalCornerRadius))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      filterValue.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w500, color: primaryColor),
                    ),
                  ),
                ),
              ));
  }
}
