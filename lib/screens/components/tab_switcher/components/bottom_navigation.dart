import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/utils/colors.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation(this.currentTab, this.onFAB, this.onTabRefresh);
  final ValueNotifier<BottomTab> currentTab;
  final Function() onFAB;
  final Function() onTabRefresh;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -1))
            ]),
            padding: EdgeInsets.only(
                top: 5, bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BottomTabButton(
                  BottomTab.home,
                  currentTab: widget.currentTab,
                  onTabRefresh: widget.onTabRefresh,
                ),
                BottomTabButton(
                  BottomTab.catalog,
                  currentTab: widget.currentTab,
                  onTabRefresh: widget.onTabRefresh,
                ),
                BottomTabButton(
                  null,
                  customOnPush: widget.onFAB,
                  onTabRefresh: widget.onTabRefresh,
                ),
                BottomTabButton(
                  BottomTab.cart,
                  currentTab: widget.currentTab,
                  onTabRefresh: widget.onTabRefresh,
                ),
                BottomTabButton(
                  BottomTab.profile,
                  currentTab: widget.currentTab,
                  onTabRefresh: widget.onTabRefresh,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onFAB,
            child: Container(
              width: 36,
              height: 36,
              decoration:
                  ShapeDecoration(shape: CircleBorder(), color: Colors.black),
              child: Center(
                child: SVGIcon(
                  icon: IconAsset.add,
                  width: 24,
                  height: 24,
                  color: accentColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
