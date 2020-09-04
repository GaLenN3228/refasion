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

    var buttonsWidth;

    if (!searchInMiddle) {
      bool hasFirstIcon = false;
      bool hasSecondIcon = false;
      bool hasText = false;

      hasFirstIcon = data.leftButtonData?.iconType != null ||
          data.rightButtonData?.iconType != null;

      hasSecondIcon = data.secondLeftButtonData?.iconType != null ||
          data.secondRightButtonData?.iconType != null;

      hasText = data.leftButtonData?.label != null ||
          data.rightButtonData?.label != null;

      if (hasFirstIcon && hasSecondIcon)
        buttonsWidth = MediaQuery.of(context).size.width * 0.25;
      else if (hasText)
        buttonsWidth = MediaQuery.of(context).size.width * 0.225;
      else if (hasFirstIcon || hasSecondIcon)
        buttonsWidth = MediaQuery.of(context).size.width * 0.15;
    }

    return Column(
      children: [
        SizedBox(
          height: data.includeTopScreenPadding
              ? MediaQuery.of(context).padding.top
              : null,
        ),
        SizedBox(
          height: 44,
          child: Row(
            children: [
              TBButtons(
                align: TBButtonsAlign.left,
                leftButton: data.leftButtonData,
                rightButton: data.secondLeftButtonData,
                buttonsWidth: buttonsWidth,
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
                leftButton: data.secondRightButtonData,
                rightButton: data.rightButtonData,
                buttonsWidth: buttonsWidth,
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
