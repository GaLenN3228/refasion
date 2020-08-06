import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/screens/components/bottom_tab_button.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation(this.currentTab, this.onFAB);
  final ValueNotifier<BottomTab> currentTab;
  final Function() onFAB;

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
                ),
                BottomTabButton(
                  BottomTab.catalog,
                  currentTab: widget.currentTab,
                ),
                BottomTabButton(
                  null,
                  customOnPush: widget.onFAB,
                ),
                BottomTabButton(
                  BottomTab.cart,
                  currentTab: widget.currentTab,
                ),
                BottomTabButton(
                  BottomTab.profile,
                  currentTab: widget.currentTab,
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
                child: SizedBox(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      "assets/small_add.svg",
                      color: Color(0xFFFAD24E),
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
