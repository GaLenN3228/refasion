import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/screens/authorization/authorization_sheet.dart';
import 'package:refashioned_app/screens/authorization/phone_page.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_navigation.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/tab_view.dart';
import 'package:refashioned_app/screens/components/scaffold/components/collect_widgets_data.dart';
import 'package:refashioned_app/screens/components/tab_switcher/tabs.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Используемый паттерн: https://medium.com/coding-with-flutter/flutter-case-study-multiple-navigators-with-bottomnavigationbar-90eb6caa6dbf
//Github: https://github.com/bizz84/nested-navigation-demo-flutter

class TabSwitcher extends StatefulWidget {
  final BottomTab initialTab;
  final CatalogNavigator catalogNavigator;
  final GlobalKey key;

  ValueNotifier<BottomTab> currentTab;

  TabSwitcher({this.key, this.initialTab: BottomTab.catalog, this.catalogNavigator});

  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  WidgetData bottomNavWidgetData;

  SizesProvider sizesProvider;

  @override
  initState() {
    sizesProvider = Provider.of<SizesProvider>(context, listen: false);

    bottomNavWidgetData = sizesProvider.getData("bottomNav") ?? WidgetData.create("bottomNav");

    widget.currentTab = ValueNotifier(widget.initialTab);

    super.initState();
  }

  onTabRefresh() {
    final canPop = navigatorKeys[widget.currentTab.value]?.currentState?.canPop() ?? false;

    if (canPop) navigatorKeys[widget.currentTab.value].currentState.pushNamedAndRemoveUntil('/', (route) => false);
  }

  pushPageOnTop(Widget page) => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => page));

  @override
  void dispose() {
    widget.currentTab.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async => !await navigatorKeys[widget.currentTab.value].currentState.maybePop(),
        child: Stack(
          children: <Widget>[
            Tabs(
              key: widget.key,
              catalogNavigator: widget.catalogNavigator,
              onTabRefresh: onTabRefresh,
              currentTab: widget.currentTab,
            ),
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
                    widget.currentTab,
                    () => {
                      BaseRepository.isAuthorized().then((isAuthorized) {
                        return isAuthorized
                            ? Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
                                    position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(animation),
                                    child: MarketplaceNavigator(
                                      onClose: () => Navigator.of(context).pop(),
                                    ),
                                  ),
                                ),
                              )
                            : showCupertinoModalBottomSheet(
                                backgroundColor: Colors.white,
                                expand: false,
                                context: context,
                                useRootNavigator: true,
                                builder: (context, controller) => AuthorizationSheet());
                      })
                    },
                    onTabRefresh,
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
