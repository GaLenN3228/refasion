import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/scaffold/data/children_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';

class ScaffoldData {
  final bool coveredWithBottomNav;
  final bool resizeToAvoidBottomInset;

  final TopBarData topBarData;
  final Widget bottomOverlay;

  final ScaffoldChildrenData childrenData;
  final Stream<ScaffoldChildrenData> childrenDataStream;

  final Map<WidgetData, ScaffoldScrollAction> scrollActions;

  const ScaffoldData({
    this.childrenData,
    this.childrenDataStream,
    this.scrollActions,
    this.topBarData,
    this.bottomOverlay,
    this.coveredWithBottomNav: true,
    this.resizeToAvoidBottomInset: false,
  }) : assert(childrenData != null || childrenDataStream != null);

  factory ScaffoldData.simple(
          {ScaffoldChildrenData childrenData,
          TBMiddleData middleData,
          Function() onBack,
          Function() onClose,
          bool coveredWithBottomNav: true,
          bool resizeToAvoidBottomInsets: false,
          Widget bottomOverlay}) =>
      ScaffoldData(
        childrenData: childrenData,
        coveredWithBottomNav: coveredWithBottomNav,
        resizeToAvoidBottomInset: resizeToAvoidBottomInsets,
        topBarData: TopBarData(
          leftButtonData: onBack != null
              ? TBButtonData.back(onTap: onBack)
              : TBButtonData.none(),
          middleData: middleData ?? TBMiddleData.none(),
          rightButtonData: onClose != null
              ? TBButtonData.close(onTap: onClose)
              : TBButtonData.none(),
        ),
        bottomOverlay: bottomOverlay ?? SizedBox(),
      );
}
