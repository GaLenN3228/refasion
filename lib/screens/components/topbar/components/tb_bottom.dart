import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_bottom_data.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_header.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_search.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';

class TBBottom extends StatelessWidget {
  final TBBottomData data;
  final TBSearchData searchData;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  const TBBottom(
      {Key key, this.data, this.scrollActionsProvider, this.searchData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (data.type) {
      case TBBottomType.search:
        return TBSearch(
          data: searchData,
          scrollActionsProvider: scrollActionsProvider,
        );

      case TBBottomType.header:
        if (data.headerText == null || data.headerText.isEmpty)
          return SizedBox();

        return TBHeader(
          text: data.headerText,
        );

      case TBBottomType.headerAndSearch:
        if (data.headerText == null || data.headerText.isEmpty)
          return SizedBox();

        return Column(
          children: [
            TBHeader(
              text: data.headerText,
            ),
            TBSearch(
              data: searchData,
              scrollActionsProvider: scrollActionsProvider,
            ),
          ],
        );

      default:
        return SizedBox();
    }
  }
}
