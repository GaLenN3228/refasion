import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/repositories/quick_filters.dart';
import 'package:refashioned_app/screens/products/components/quick_filter_item.dart';
import 'package:provider/provider.dart';

class QuickFilterList extends StatefulWidget {
  final double horizontalHeight;
  final EdgeInsets padding;
  final Function() onUpdate;
  final String categoryName;
  final List<Category> categories;
  final Function(String) updateProducts;

  const QuickFilterList(
      {Key key,
      this.horizontalHeight: 30.0,
      this.padding,
      this.onUpdate,
      this.categoryName,
      this.categories,
      this.updateProducts})
      : super(key: key);

  @override
  _QuickFilterListState createState() => _QuickFilterListState();
}

class _QuickFilterListState extends State<QuickFilterList> {
  @override
  Widget build(BuildContext context) {
    final QuickFiltersRepository quickFiltersRepository = context.watch<QuickFiltersRepository>();

    if (quickFiltersRepository.isLoading || quickFiltersRepository.loadingFailed) return Container();

    return SizedBox(
      height: widget.horizontalHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories != null
            ? quickFiltersRepository.quickFiltersResponse.content.length + 1
            : quickFiltersRepository.quickFiltersResponse.content.length,
        padding: widget.padding ?? EdgeInsets.zero,
        itemBuilder: (context, index) {
          return QuickFilterItem(
              onUpdate: widget.onUpdate,
              categoryName: widget.categoryName,
              categories: widget.categories,
              isNavigationButton: widget.categories != null ? index == 0 : false,
              horizontalHeight: widget.horizontalHeight,
              filterValue: widget.categories != null
                  ? ((index > 0) ? quickFiltersRepository.quickFiltersResponse.content.elementAt(index - 1) : null)
                  : quickFiltersRepository.quickFiltersResponse.content.elementAt(index),
              onSelect: (urlParameter) {
                setState(() {
                  quickFiltersRepository.quickFiltersResponse.update(urlParams: urlParameter);
                });
              },
              updateProducts: widget.updateProducts);
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 5,
          );
        },
      ),
    );
  }
}
