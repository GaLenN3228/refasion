import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_buttons.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';

class TBContent extends StatelessWidget {
  final TopBarData data;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  const TBContent({Key key, this.data, this.scrollActionsProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null) return SizedBox();

    final searchInMiddle = data.middleData == null;

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
        SizedBox(
          height: 44,
          child: Row(
            children: [
              TBButtons(
                align: TBButtonsAlign.left,
                searchInMiddle: searchInMiddle,
                leftButton: data.leftButtonData,
                rightButton: data.secondLeftButtonData,
              ),
              Expanded(
                child: TBMiddle(
                  data: data.middleData,
                  searchData: data.searchData,
                  scrollActionsProvider: scrollActionsProvider,
                  showCancelSearchButton: data.secondRightButtonData == null &&
                      data.rightButtonData == null,
                ),
              ),
              TBButtons(
                align: TBButtonsAlign.right,
                searchInMiddle: searchInMiddle,
                leftButton: data.secondRightButtonData,
                rightButton: data.rightButtonData,
              ),
            ],
          ),
        ),
        TBBottom(
          data: data.bottomData,
          searchData: data.searchData,
          scrollActionsProvider: scrollActionsProvider,
          searchInMiddle: searchInMiddle,
        ),
      ],
    );
  }
}
