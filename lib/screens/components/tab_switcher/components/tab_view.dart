import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/cart/cart_navigator.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_wrapper_page.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/screens_navigator.dart';

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

  tabListener() async {
    final newTab = widget.currentTab.value;

    final canPop = await navigatorKeys[currentTab]?.currentState?.maybePop() ?? false;

    if (currentTab != newTab)
      setState(() => currentTab = newTab);
    else if (canPop) navigatorKeys[currentTab].currentState.pushNamedAndRemoveUntil('/', (route) => false);
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
        var catalogNavigator = CatalogNavigator(
            navigatorKey: navigatorKeys[currentTab]);
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController())
            ],
            builder: (context, _) {
              return CatalogWrapperPage(
                catalogNavigator: catalogNavigator,
                onFavClick: () {
                  return Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => catalogNavigator.routeBuilder(context, ScreenNavigatorRoutes.fav)));
                },
                navigatorKey: navigatorKeys[currentTab],
              );
            });
        break;

      case BottomTab.cart:
        content = CartNavigator(navigatorKey: navigatorKeys[widget.tab], needUpdate: currentTab == widget.tab);
        break;

//       case BottomTab.profile:
//         content = CupertinoPageScaffold(
//           resizeToAvoidBottomInset: false,
//           child: ProfilePage(),
//         );
//         break;

      default:
        content = Center(
          child: Text(
            "Вкладка " + widget.tab.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
        break;
    }

    return Offstage(
      offstage: currentTab != widget.tab,
      child: CupertinoPageScaffold(
        child: content,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
