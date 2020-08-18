import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/cart/pages/cart.dart';
import 'package:refashioned_app/screens/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/catalog_navigator.dart';

final navigatorKeys = {
  BottomTab.home: GlobalKey<NavigatorState>(),
  BottomTab.catalog: GlobalKey<NavigatorState>(),
  BottomTab.cart: GlobalKey<NavigatorState>(),
  BottomTab.profile: GlobalKey<NavigatorState>(),
};

class TabView extends StatefulWidget {
  final BottomTab tab;
  final ValueNotifier<BottomTab> currentTab;
  final Function(Widget) pushPageOnTop;

  const TabView(this.tab, this.currentTab, {this.pushPageOnTop});

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  BottomTab currentTab;

  @override
  void initState() {
    currentTab = widget.currentTab.value;

    widget.currentTab?.addListener(tabListener);

    super.initState();
  }

  tabListener() {
    final newTab = widget.currentTab.value;

    setState(() {
      if (currentTab != newTab)
        currentTab = newTab;
      else
        navigatorKeys[currentTab]
            .currentState
            .pushNamedAndRemoveUntil('/', (_) => false);
    });
  }

  @override
  void dispose() {
    widget.currentTab?.removeListener(tabListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (widget.tab) {
      case BottomTab.catalog:
        content = CupertinoPageScaffold(
          child: CatalogNavigator(
              navigatorKey: navigatorKeys[widget.tab],
              onPushPageOnTop: widget.pushPageOnTop),
        );
        break;

      case BottomTab.cart:
        content = CupertinoPageScaffold(
          child: CartPage(needUpdate: currentTab == widget.tab),
        );
        break;

//       case BottomTab.profile:
//         content = CupertinoPageScaffold(
//           resizeToAvoidBottomInset: false,
//           child: ProfilePage(),
//         );
//         break;

      default:
        content = CupertinoPageScaffold(
          child: Center(
            child: Text(
              "Вкладка " + widget.tab.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
        break;
    }

    return Offstage(
      offstage: currentTab != widget.tab,
      child: CupertinoPageScaffold(child: content),
    );
  }
}
