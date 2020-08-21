import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_bottom_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';

class TopBarData {
  final TBButtonData leftButtonData;
  final TBButtonData secondLeftButtonData;

  final TBMiddleData middleData;

  final TBButtonData secondRightButtonData;
  final TBButtonData rightButtonData;

  final TBBottomData bottomData;

  final TBSearchData searchData;

  final bool shouldElevateOnScroll;

  final Color backgroundColor;

  const TopBarData({
    this.backgroundColor,
    this.leftButtonData,
    this.secondLeftButtonData,
    this.middleData,
    this.secondRightButtonData,
    this.rightButtonData,
    this.bottomData,
    this.searchData,
    this.shouldElevateOnScroll: true,
  }) : assert(leftButtonData != null ||
            middleData != null ||
            bottomData != null ||
            rightButtonData != null);

  factory TopBarData.sellerPage(
          {Function() leftAction,
          Function() rightAction,
          String titleText,
          String headerText}) =>
      TopBarData(
        leftButtonData: leftAction != null
            ? TBButtonData.back(onTap: leftAction)
            : TBButtonData.none(),
        middleData: titleText != null
            ? TBMiddleData.title(titleText)
            : TBMiddleData.none(),
        rightButtonData: rightAction != null
            ? TBButtonData.close(onTap: rightAction)
            : TBButtonData.none(),
        bottomData: headerText != null
            ? TBBottomData(
                type: TBBottomType.header,
                headerText: headerText,
              )
            : TBBottomData.none(),
      );
}
