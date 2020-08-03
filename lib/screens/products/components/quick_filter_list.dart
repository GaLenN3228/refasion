import 'package:flutter/material.dart';
import 'package:refashioned_app/repositories/quick_filters.dart';
import 'package:refashioned_app/screens/products/components/quick_filter_item.dart';
import 'package:provider/provider.dart';

class QuickFilterList extends StatefulWidget {
  final double horizontalHeight;
  final EdgeInsets padding;

  const QuickFilterList({Key key, this.horizontalHeight: 30.0, this.padding}) : super(key: key);

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
        itemCount: quickFiltersRepository.quickFiltersResponse.content.length + 1,
        padding: widget.padding ?? EdgeInsets.zero,
        itemBuilder: (context, index) {
          return QuickFilterItem(
              isNavigationButton: index == 0,
              horizontalHeight: widget.horizontalHeight,
              filterValue:
                  (index > 0) ? quickFiltersRepository.quickFiltersResponse.content.elementAt(index - 1) : null,
              onSelect: (urlParameter) {
                setState(() {
                  quickFiltersRepository.quickFiltersResponse.update(urlParams: urlParameter);
                });
              });
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
