import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/cart/pages/cart.dart';
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
    TabItem.sell: GlobalKey<NavigatorState>(),
    TabItem.cart: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  TabItem currentTab = TabItem.catalog;
  bool showTabBar = true;

  void _selectTab(TabItem tabItem) {
    if (currentTab != tabItem) {
      setState(() {
        currentTab = tabItem;

        if (tabItem == TabItem.sell && showTabBar)
          showTabBar = false;
        else if (!showTabBar) showTabBar = true;
      });
    } else {
      navigatorKeys[tabItem]
          .currentState
          .pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  void _hideTabBar() {
    setState(() {
      showTabBar = false;
    });
  }

  void _showTabBar() {
    setState(() {
      showTabBar = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          return !await navigatorKeys[currentTab].currentState.maybePop();
        },
        child: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.home),
          _buildOffstageNavigator(TabItem.catalog,
              hideTabBar: _hideTabBar, showTabBar: _showTabBar),
          _buildOffstageNavigator(
            TabItem.sell,
            hideTabBar: _hideTabBar,
          ),
          _buildOffstageNavigator(TabItem.cart),
          _buildOffstageNavigator(TabItem.profile),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: showTabBar
                ? BottomNavigation(
                    currentTab: currentTab,
                    onSelectTab: _selectTab,
                  )
                : SizedBox(),
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
          child: Scaffold(
            body: CatalogNavigator(
                navigatorKey: navigatorKeys[tabItem],
                hideTabBar: hideTabBar,
                showTabBar: showTabBar),
          ),
        );

      case TabItem.cart:
        return Offstage(
          offstage: currentTab != tabItem,
          child: Scaffold(
            body: CartPage(),
          ),
        );

      case TabItem.sell:
        return Offstage(
          offstage: currentTab != tabItem,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SellNavigator(navigatorKey: navigatorKeys[tabItem]),
          ),
        );

      default:
        return Offstage(
          offstage: currentTab != tabItem,
          child: Scaffold(
            body: Center(
              child: Text(tabItem.toString()),
            ),
          ),
        );
    }
  }
}
