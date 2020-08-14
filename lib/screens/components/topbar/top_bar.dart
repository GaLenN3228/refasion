import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_search.dart';

class RefashionedTopBar extends StatefulWidget {
  final TBSearchController searchController;

  final TBButtonType leftButtonType;
  final Function() leftButtonAction;
  final String leftButtonText;
  final Color leftButtonTextColor;
  final TBIconType leftButtonIcon;
  final Color leftButtonIconColor;

  final TBButtonType secondLeftButtonType;
  final Function() secondLeftButtonAction;
  final String secondLeftButtonText;
  final Color secondLeftButtonTextColor;
  final TBIconType secondLeftButtonIcon;
  final Color secondLeftButtonIconColor;

  final TBMiddleType middleType;
  final String middleTitleText;
  final String middleSubtitleText;

  final TBButtonType rightButtonType;
  final Function() rightButtonAction;
  final String rightButtonText;
  final Color rightButtonTextColor;
  final TBIconType rightButtonIcon;
  final Color rightButtonIconColor;

  final TBButtonType secondRightButtonType;
  final Function() secondRightButtonAction;
  final String secondRightButtonText;
  final Color secondRightButtonTextColor;
  final TBIconType secondRightButtonIcon;
  final Color secondRightButtonIconColor;

  final TBBottomType bottomType;
  final String bootomHeaderText;

  final String searchHintText;
  final Function(String) onSearchUpdate;
  final Function() onSearchFocus;
  final Function() onSearchUnfocus;
  final bool autofocus;

  final ScrollController scrollController;
  final double scrollPastOffset;

  final Widget customBottom;

  const RefashionedTopBar({
    this.leftButtonType: TBButtonType.none,
    this.secondLeftButtonType: TBButtonType.none,
    this.middleType: TBMiddleType.none,
    this.rightButtonType: TBButtonType.none,
    this.secondRightButtonType: TBButtonType.none,
    this.bottomType: TBBottomType.none,
    this.leftButtonText,
    this.leftButtonAction,
    this.leftButtonIcon,
    this.leftButtonTextColor,
    this.rightButtonText,
    this.rightButtonAction,
    this.rightButtonIcon,
    this.rightButtonTextColor,
    this.middleTitleText,
    this.middleSubtitleText,
    this.leftButtonIconColor,
    this.rightButtonIconColor,
    this.bootomHeaderText,
    this.searchHintText,
    this.onSearchUpdate,
    this.onSearchFocus,
    this.onSearchUnfocus,
    this.autofocus,
    this.customBottom,
    this.searchController,
    this.secondLeftButtonAction,
    this.secondLeftButtonText,
    this.secondLeftButtonTextColor,
    this.secondLeftButtonIcon,
    this.secondLeftButtonIconColor,
    this.secondRightButtonAction,
    this.secondRightButtonText,
    this.secondRightButtonTextColor,
    this.secondRightButtonIcon,
    this.secondRightButtonIconColor,
    this.scrollController,
    this.scrollPastOffset,
  }) : assert(leftButtonType != null &&
            secondLeftButtonType != null &&
            middleType != null &&
            rightButtonType != null &&
            secondRightButtonType != null &&
            bottomType != null &&
            (middleType != TBMiddleType.search ||
                bottomType != TBBottomType.search));

  @override
  _RefashionedTopBarState createState() => _RefashionedTopBarState();
}

class _RefashionedTopBarState extends State<RefashionedTopBar>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isElevated;
  ValueNotifier<bool> isScrolledPastOffset;

  AnimationController animationController;
  Animation<double> animation;

  final flatShadow = null;
  final elevatedShadow = BoxShadow(
      color: Colors.black.withOpacity(0.05),
      offset: Offset(0, 4),
      blurRadius: 4);

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    isElevated = ValueNotifier(false);

    isScrolledPastOffset = ValueNotifier(false);

    widget.scrollController?.addListener(scrollListener);

    isElevated.addListener(scrollStateListener);

    super.initState();
  }

  scrollListener() {
    isElevated.value = widget.scrollController.offset >
        widget.scrollController.position.minScrollExtent;

    isScrolledPastOffset.value =
        widget.scrollController.offset > widget.scrollPastOffset;
  }

  scrollStateListener() {
    if (isElevated.value)
      animationController.forward();
    else
      animationController.reverse();
  }

  @override
  void dispose() {
    isElevated.removeListener(scrollStateListener);

    widget.scrollController?.removeListener(scrollListener);

    isElevated.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidth = widget.middleType != TBMiddleType.search
        ? MediaQuery.of(context).size.width * 0.3
        : null;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Container(
        child: child,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow.lerp(flatShadow, elevatedShadow, animation.value)
          ],
        ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TBButton(
                        widget.leftButtonType,
                        TBButtonAlign.left,
                        onTap: widget.leftButtonAction,
                        text: widget.leftButtonText,
                        textColor: widget.leftButtonTextColor,
                        icon: widget.leftButtonIcon,
                        iconColor: widget.leftButtonIconColor,
                      ),
                      TBButton(
                        widget.secondLeftButtonType,
                        TBButtonAlign.left,
                        onTap: widget.secondLeftButtonAction,
                        text: widget.secondLeftButtonText,
                        textColor: widget.secondLeftButtonTextColor,
                        icon: widget.secondLeftButtonIcon,
                        iconColor: widget.secondLeftButtonIconColor,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TBMiddle(
                    widget.middleType,
                    titleText: widget.middleTitleText,
                    subtitleText: widget.middleSubtitleText,
                    searchHintText: widget.searchHintText,
                    onSearchUpdate: widget.onSearchUpdate,
                    onSearchFocus: widget.onSearchFocus,
                    onSearchUnfocus: widget.onSearchUnfocus,
                    searchController: widget.searchController,
                    isElevated: isElevated,
                    isScrolledPastOffset: isScrolledPastOffset,
                  ),
                ),
                SizedBox(
                  width: buttonWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TBButton(
                        widget.secondRightButtonType,
                        TBButtonAlign.right,
                        onTap: widget.secondRightButtonAction,
                        text: widget.secondRightButtonText,
                        textColor: widget.secondRightButtonTextColor,
                        icon: widget.secondRightButtonIcon,
                        iconColor: widget.secondRightButtonIconColor,
                      ),
                      TBButton(
                        widget.rightButtonType,
                        TBButtonAlign.right,
                        onTap: widget.rightButtonAction,
                        text: widget.rightButtonText,
                        textColor: widget.rightButtonTextColor,
                        icon: widget.rightButtonIcon,
                        iconColor: widget.rightButtonIconColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TBBottom(
            type: widget.bottomType,
            headerText: widget.bootomHeaderText,
            searchHintText: widget.searchHintText,
            onSearchUpdate: widget.onSearchUpdate,
            onSearchFocus: widget.onSearchFocus,
            onSearchUnfocus: widget.onSearchUnfocus,
            searchController: widget.searchController,
            isElevated: isElevated,
          ),
          widget.customBottom ?? SizedBox(),
        ],
      ),
    );
  }
}
