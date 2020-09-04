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
  final bool includeTopScreenPadding;

  final Color backgroundColor;

  const TopBarData({
    this.includeTopScreenPadding: true,
    this.backgroundColor,
    this.leftButtonData,
    this.secondLeftButtonData,
    this.middleData,
    this.secondRightButtonData,
    this.rightButtonData,
    this.bottomData,
    this.searchData,
    this.shouldElevateOnScroll: true,
  });

  factory TopBarData.simple(
          {Function() onBack,
          Function() onClose,
          String middleText,
          String bottomText,
          bool includeTopScreenPadding}) =>
      onBack != null ||
              onClose != null ||
              middleText != null ||
              bottomText != null
          ? TopBarData(
              leftButtonData: onBack != null
                  ? TBButtonData.icon(TBIconType.back, onTap: onBack)
                  : null,
              middleData: TBMiddleData.title(middleText),
              rightButtonData: onClose != null
                  ? TBButtonData.text("Закрыть", onTap: onClose)
                  : null,
              bottomData: TBBottomData.header(bottomText),
              includeTopScreenPadding: includeTopScreenPadding ?? true,
            )
          : null;
}
