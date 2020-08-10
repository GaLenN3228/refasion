import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_bottom.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_button.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_middle.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_search.dart';

class TopBar extends StatelessWidget {
  final TBSearchController searchController;

  final TBButtonType leftButtonType;
  final Function() leftButtonAction;
  final String leftButtonText;
  final Color leftButtonTextColor;
  final TBIconType leftButtonIcon;
  final Color leftButtonIconColor;

  final TBMiddleType middleType;
  final String middleText;

  final TBButtonType rightButtonType;
  final Function() rightButtonAction;
  final String rightButtonText;
  final Color rightButtonTextColor;
  final TBIconType rightButtonIcon;
  final Color rightButtonIconColor;

  final TBBottomType bottomType;
  final String bootomHeaderText;

  final String searchHintText;
  final Function(String) onSearchUpdate;
  final Function() onSearchFocus;
  final Function() onSearchUnfocus;
  final bool autofocus;

  final ValueNotifier<bool> isElevated;

  final Widget customBottom;

  const TopBar({
    this.leftButtonType,
    this.middleType,
    this.rightButtonType,
    this.leftButtonText,
    this.leftButtonAction,
    this.leftButtonIcon,
    this.leftButtonTextColor,
    this.rightButtonText,
    this.rightButtonAction,
    this.rightButtonIcon,
    this.rightButtonTextColor,
    this.middleText,
    this.leftButtonIconColor,
    this.rightButtonIconColor,
    this.bottomType,
    this.bootomHeaderText,
    this.isElevated,
    this.searchHintText,
    this.onSearchUpdate,
    this.onSearchFocus,
    this.onSearchUnfocus,
    this.autofocus,
    this.customBottom,
    this.searchController,
  }) : assert(leftButtonType != null &&
            middleType != null &&
            rightButtonType != null &&
            bottomType != null);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = middleType != TBMiddleType.search
        ? MediaQuery.of(context).size.width * 0.25
        : null;

    return ValueListenableBuilder(
      valueListenable: isElevated ?? ValueNotifier(false),
      builder: (context, value, child) => Container(
        child: child,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: (value)
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 4),
                        blurRadius: 4)
                  ]
                : []),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          SizedBox(
            height: 44,
            child: Row(
              children: [
                SizedBox(
                  width: buttonWidth,
                  child: TBButton(
                    leftButtonType,
                    TBButtonAlign.left,
                    onTap: leftButtonAction,
                    text: leftButtonText,
                    textColor: leftButtonTextColor,
                    icon: leftButtonIcon,
                    iconColor: leftButtonIconColor,
                  ),
                ),
                Expanded(
                  child: TBMiddle(
                    middleType,
                    text: middleText,
                  ),
                ),
                SizedBox(
                  width: buttonWidth,
                  child: TBButton(
                    rightButtonType,
                    TBButtonAlign.right,
                    onTap: rightButtonAction,
                    text: rightButtonText,
                    textColor: rightButtonTextColor,
                    icon: rightButtonIcon,
                    iconColor: rightButtonIconColor,
                  ),
                ),
              ],
            ),
          ),
          TBBottom(
            type: bottomType,
            headerText: bootomHeaderText,
            searchHintText: searchHintText,
            onSearchUpdate: onSearchUpdate,
            onSearchFocus: onSearchFocus,
            onSearchUnfocus: onSearchUnfocus,
            searchController: searchController,
          ),
          customBottom ?? SizedBox(),
        ],
      ),
    );
  }
}
