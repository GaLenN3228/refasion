import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/cart/pages/cart.dart';
import 'package:refashioned_app/screens/profile/profile.dart';
import 'package:refashioned_app/screens/sell_product/pages/sell_navigator.dart';
import 'components/bottom_navigation.dart';
import 'components/catalog_navigator.dart';

//Используемый паттерн: https://medium.com/coding-with-flutter/flutter-case-study-multiple-navigators-with-bottomnavigationbar-90eb6caa6dbf
//Github: https://github.com/bizz84/nested-navigation-demo-flutter

class TabSwitcher extends StatefulWidget {
  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.catalog: GlobalKey<NavigatorState>(),
    TabItem.cart: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  TabItem currentTab = TabItem.catalog;

  void _selectTab(TabItem tabItem) {
    if (currentTab != tabItem) {
      setState(() {
        currentTab = tabItem;
      });
    } else {
      navigatorKeys[tabItem]
          .currentState
          .pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  _pushPageOnTop(Widget page) => Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => page));

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: WillPopScope(
        onWillPop: () async {
          return !await navigatorKeys[currentTab].currentState.maybePop();
        },
        child: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.home),
          _buildOffstageNavigator(TabItem.catalog),
          _buildOffstageNavigator(TabItem.sell),
          _buildOffstageNavigator(TabItem.cart),
          _buildOffstageNavigator(TabItem.profile),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: BottomNavigation(
              currentTab: currentTab,
              onSelectTab: _selectTab,
              onFAB: () {
                final navigatorKey = GlobalKey<NavigatorState>();

                return _pushPageOnTop(
                  WillPopScope(
                      onWillPop: () async {
                        return !await navigatorKey.currentState.maybePop();
                      },
                      child: SellNavigator(
                          onClose: () => Navigator.of(context).pop())),
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem,
      {Function() hideTabBar, Function() showTabBar}) {
    switch (tabItem) {
      case TabItem.catalog:
        return Offstage(
          offstage: currentTab != tabItem,
          child: CupertinoPageScaffold(
            child: CatalogNavigator(
                navigatorKey: navigatorKeys[tabItem],
                onPushPageOnTop: _pushPageOnTop),
          ),
        );

      case TabItem.cart:
        return Offstage(
          offstage: currentTab != tabItem,
          child: CupertinoPageScaffold(
            child: CartPage(needUpdate: currentTab == tabItem),
          ),
        );

      // case TabItem.sell:
      // return
      //   return Offstage(
      //     offstage: currentTab != tabItem,
      //     child: CupertinoPageScaffold(
      //       resizeToAvoidBottomInset: false,
      //       child: SellNavigator(navigatorKey: navigatorKeys[tabItem]),
      //     ),
      //   );

      // case TabItem.profile:
      //   return Offstage(
      //     offstage: currentTab != tabItem,
      //     child: CupertinoPageScaffold(
      //       resizeToAvoidBottomInset: false,
      //       child: ProfilePage(),
      //     ),
      //   );

      default:
        return Offstage(
          offstage: currentTab != tabItem,
          child: CupertinoPageScaffold(
            child: Center(
              child: Text(
                "Вкладка " + tabItem.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        );
    }
  }
}
