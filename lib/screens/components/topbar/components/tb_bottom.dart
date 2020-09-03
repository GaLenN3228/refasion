import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/search/tb_search.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_bottom_data.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_header.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';

class TBBottom extends StatelessWidget {
  final TBBottomData data;
  final TBSearchData searchData;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  final bool searchInMiddle;

  const TBBottom(
      {Key key,
      this.data,
      this.searchData,
      this.scrollActionsProvider,
      this.searchInMiddle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null && searchData == null) return SizedBox();

    if (!searchInMiddle && searchData != null)
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: TBSearch(
          data: searchData,
          scrollActionsProvider: scrollActionsProvider,
        ),
      );

    return TBHeader(
      text: data.headerText,
    );
  }
}
