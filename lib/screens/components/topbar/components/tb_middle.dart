import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_search.dart';

enum TBMiddleType { text, search, none }

class TBMiddle extends StatelessWidget {
  final TBMiddleType type;
  final String titleText;

  final String searchHintText;
  final Function(String) onSearchUpdate;
  final Function() onSearchFocus;
  final Function() onSearchUnfocus;

  final TBSearchController searchController;

  const TBMiddle(this.type,
      {this.titleText,
      this.searchHintText,
      this.onSearchUpdate,
      this.onSearchFocus,
      this.onSearchUnfocus,
      this.searchController})
      : assert(type != null);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TBMiddleType.text:
        if (titleText == null || titleText.isEmpty) return SizedBox();

        return Text(
          titleText.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        );

      case TBMiddleType.search:
        return TBSearch(
          hintText: searchHintText,
          onSearchUpdate: onSearchUpdate,
          onFocus: onSearchFocus,
          onUnfocus: onSearchUnfocus,
          searchController: searchController,
        );

      default:
        return SizedBox();
    }
  }
}
