import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_navigation.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/tab_view.dart';
import 'package:refashioned_app/screens/components/scaffold/components/collect_widgets_data.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';

//Используемый паттерн: https://medium.com/coding-with-flutter/flutter-case-study-multiple-navigators-with-bottomnavigationbar-90eb6caa6dbf
//Github: https://github.com/bizz84/nested-navigation-demo-flutter

class TabSwitcher extends StatefulWidget {
  final BottomTab initialTab;

  const TabSwitcher({Key key, this.initialTab: BottomTab.catalog})
      : super(key: key);

  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  WidgetData bottomNavWidgetData;

  SizesProvider sizesProvider;

  ValueNotifier<BottomTab> currentTab;

  @override
  initState() {
    sizesProvider = Provider.of<SizesProvider>(context, listen: false);

    bottomNavWidgetData =
        sizesProvider.getData("bottomNav") ?? WidgetData.create("bottomNav");

    currentTab = ValueNotifier(widget.initialTab);

    super.initState();
  }

  pushPageOnTop(Widget page) => Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => page));

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: WillPopScope(
        onWillPop: () async =>
            !await navigatorKeys[currentTab.value].currentState.maybePop(),
        child: Stack(
          children: <Widget>[
            TabView(BottomTab.home, currentTab),
            TabView(
              BottomTab.catalog,
              currentTab,
              pushPageOnTop: pushPageOnTop,
            ),
            TabView(BottomTab.cart, currentTab),
            TabView(BottomTab.profile, currentTab),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: CollectWidgetsData(
                widgets: [bottomNavWidgetData],
                sizesProvider: sizesProvider,
                child: SizedBox(
                  key: bottomNavWidgetData.key,
                  child: BottomNavigation(
                    currentTab,
                    () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SlideTransition(
                          position: Tween(begin: Offset(0, 1), end: Offset.zero)
                              .animate(animation),
                          child: MarketplaceNavigator(
                            onClose: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
