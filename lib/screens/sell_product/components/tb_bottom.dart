import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_search.dart';

enum TBBottomType { search, header, none }

class TBBottom extends StatelessWidget {
  final TBBottomType type;
  final String headerText;

  final String searchHintText;
  final Function(String) onSearchUpdate;
  final Function() onSearchFocus;
  final Function() onSearchUnfocus;

  final TBSearchController searchController;

  const TBBottom(
      {this.type,
      this.headerText,
      this.onSearchUpdate,
      this.searchHintText,
      this.onSearchFocus,
      this.onSearchUnfocus,
      this.searchController})
      : assert(type != null);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TBBottomType.search:
        return TBSearch(
          hintText: searchHintText,
          onSearchUpdate: onSearchUpdate,
          onFocus: onSearchFocus,
          onUnfocus: onSearchUnfocus,
          searchController: searchController,
        );

      case TBBottomType.header:
        if (headerText == null || headerText.isEmpty) return SizedBox();

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 11, 20, 16),
          child: Center(
            child: Text(
              headerText,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        );

      default:
        return SizedBox();
    }
  }
}
