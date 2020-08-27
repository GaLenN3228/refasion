import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/scaffold/data/children_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';

class ScaffoldData {
  final bool adjustToOverlays;
  final bool coveredWithBottomNav;
  final bool resizeToAvoidBottomInset;

  final bool raiseTopBarIfIsScrolled;
  final bool lowerTopBarIfIsntScrolled;
  final bool focusSearchOnScrollUpFromStart;
  final bool unfocusSearchOnAnyOtherScroll;
  final bool overrideRightButtonsWithCancelSearchButton;

  final TopBarData topBarData;
  final Widget bottomOverlay;

  final ScaffoldChildrenData childrenData;
  final Stream<ScaffoldChildrenData> childrenDataStream;

  final Map<WidgetData, ScaffoldScrollAction> scrollActions;

  const ScaffoldData({
    this.adjustToOverlays: true,
    this.childrenData,
    this.childrenDataStream,
    this.scrollActions,
    this.topBarData,
    this.bottomOverlay,
    this.coveredWithBottomNav: true,
    this.resizeToAvoidBottomInset: false,
    this.raiseTopBarIfIsScrolled: true,
    this.lowerTopBarIfIsntScrolled: true,
    this.focusSearchOnScrollUpFromStart: true,
    this.unfocusSearchOnAnyOtherScroll: true,
    this.overrideRightButtonsWithCancelSearchButton: true,
  }) : assert(childrenData != null || childrenDataStream != null);

  factory ScaffoldData.simple(
          {ScaffoldChildrenData childrenData,
          TBMiddleData middleData,
          Function() onBack,
          Function() onClose,
          bool adjustToOverlays: true,
          bool coveredWithBottomNav: true,
          bool resizeToAvoidBottomInsets: false,
          Widget bottomOverlay}) =>
      ScaffoldData(
        childrenData: childrenData,
        adjustToOverlays: adjustToOverlays,
        coveredWithBottomNav: coveredWithBottomNav,
        resizeToAvoidBottomInset: resizeToAvoidBottomInsets,
        topBarData: TopBarData(
          leftButtonData: onBack != null
              ? TBButtonData.icon(TBIconType.back, onTap: onBack)
              : null,
          middleData: middleData,
          rightButtonData: onClose != null
              ? TBButtonData.text("Закрыть", onTap: onClose)
              : null,
        ),
        bottomOverlay: bottomOverlay,
      );
}
