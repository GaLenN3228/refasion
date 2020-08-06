import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/repositories/quick_filters.dart';
import 'package:refashioned_app/screens/products/components/quick_filter_item.dart';
import 'package:provider/provider.dart';

class QuickFilterList extends StatefulWidget {
  final double horizontalHeight;
  final EdgeInsets padding;
  final Category topCategory;
  final Function() updateProducts;

  const QuickFilterList(
      {Key key, this.horizontalHeight: 30.0, this.padding, this.updateProducts, this.topCategory})
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
        itemCount: widget.topCategory != null && widget.topCategory.children != null
            ? quickFiltersRepository.quickFiltersResponse.content.length + 1
            : quickFiltersRepository.quickFiltersResponse.content.length,
        padding: widget.padding ?? EdgeInsets.zero,
        itemBuilder: (context, index) {
          return QuickFilterItem(
              topCategory: widget.topCategory,
              isNavigationButton: widget.topCategory != null && widget.topCategory.children != null ? index == 0 : false,
              horizontalHeight: widget.horizontalHeight,
              filterValue: widget.topCategory != null && widget.topCategory.children != null
                  ? ((index > 0) ? quickFiltersRepository.quickFiltersResponse.content.elementAt(index - 1) : null)
                  : quickFiltersRepository.quickFiltersResponse.content.elementAt(index),
              onSelect: (urlParameter) {
                setState(() {
                  quickFiltersRepository.update(urlParams: urlParameter);
                });
                widget.updateProducts();
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
