import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_header.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_search.dart';

enum TBBottomType { search, header, headerAndSearch, none }

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

        return TBHeader(
          text: headerText,
        );

      case TBBottomType.headerAndSearch:
        if (headerText == null || headerText.isEmpty) return SizedBox();

        return Column(
          children: [
            TBHeader(
              text: headerText,
            ),
            TBSearch(
              hintText: searchHintText,
              onSearchUpdate: onSearchUpdate,
              onFocus: onSearchFocus,
              onUnfocus: onSearchUnfocus,
              searchController: searchController,
            ),
          ],
        );

      default:
        return SizedBox();
    }
  }
}
