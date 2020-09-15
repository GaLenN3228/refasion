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
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tabs extends StatefulWidget {
  final CatalogNavigator catalogNavigator;
  final GlobalKey key;
  final Function() onTabRefresh;
  final Function(Widget) pushPageOnTop;

  final ValueNotifier<BottomTab> currentTab;

  Tabs(
      {this.key,
      this.catalogNavigator,
      this.onTabRefresh,
      this.currentTab,
      this.pushPageOnTop});

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  void dispose() {
    widget.currentTab.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.key,
      initialRoute: '/',
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
            builder: (context) => Stack(
                  children: <Widget>[
                    TabView(
                      BottomTab.home,
                      widget.currentTab,
                      onTabRefresh: widget.onTabRefresh,
                    ),
                    TabView(
                      BottomTab.catalog,
                      widget.currentTab,
                      pushPageOnTop: widget.pushPageOnTop,
                      onTabRefresh: widget.onTabRefresh,
                      catalogNavigator: widget.catalogNavigator,
                    ),
                    TabView(
                      BottomTab.cart,
                      widget.currentTab,
                      onTabRefresh: widget.onTabRefresh,
                    ),
                    TabView(
                      BottomTab.profile,
                      widget.currentTab,
                      onTabRefresh: widget.onTabRefresh,
                      catalogNavigator: widget.catalogNavigator,
                    ),
                  ],
                ));
      },
    );
  }
}
