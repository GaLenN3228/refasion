import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/repositories/quick_filters.dart';
import 'package:refashioned_app/screens/products/components/quick_filter_item.dart';
import 'package:provider/provider.dart';

class QuickFilterList extends StatefulWidget {
  final double horizontalHeight;
  final EdgeInsets padding;
  final Category topCategory;
  final List<Category> categories;
  final Function() updateProducts;

  const QuickFilterList(
      {Key key, this.horizontalHeight: 30.0, this.padding, this.updateProducts, this.topCategory, this.categories})
      : super(key: key);

  @override
  _QuickFilterListState createState() => _QuickFilterListState();
}

class _QuickFilterListState extends State<QuickFilterList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuickFiltersRepository>(builder: (context, quickFiltersRepository, child) {
      return quickFiltersRepository.isLoaded
          ? SizedBox(
              height: widget.horizontalHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.topCategory != null && widget.categories != null
                    ? quickFiltersRepository.response.content.length + 1
                    : quickFiltersRepository.response.content.length,
                padding: widget.padding ?? EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return QuickFilterItem(
                      topCategory: widget.topCategory,
                      categories: widget.categories,
                      isNavigationButton:
                          widget.topCategory != null && widget.categories != null
                              ? index == 0
                              : false,
                      horizontalHeight: widget.horizontalHeight,
                      filterValue: widget.topCategory != null && widget.categories != null
                          ? ((index > 0)
                              ? quickFiltersRepository.response.content.elementAt(index - 1)
                              : null)
                          : quickFiltersRepository.response.content.elementAt(index),
                      onSelect: (urlParameter, prices) {
                        setState(() {
                          quickFiltersRepository.update(id: urlParameter, price: prices);
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
            )
          : SizedBox();
    });
  }
}
