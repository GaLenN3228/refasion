import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/cart/cart_navigator.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/home/home_navigator.dart';
import 'package:refashioned_app/screens/profile/profile_navigator.dart';
import 'package:refashioned_app/screens/search_wrapper.dart';

final navigatorKeys = {
  BottomTab.home: GlobalKey<NavigatorState>(),
  BottomTab.catalog: GlobalKey<NavigatorState>(),
  BottomTab.cart: GlobalKey<NavigatorState>(),
  BottomTab.profile: GlobalKey<NavigatorState>(),
};

class TabView extends StatelessWidget {
  final BottomTab tab;
  final ValueNotifier<BottomTab> currentTab;
  final Function(Widget) pushPageOnTop;
  final Function() onTabRefresh;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    PickPoint pickUpAddress,
    Function() onClose,
    Function(String, String) onFinish,
  }) openDeliveryTypesSelector;

  TabView(this.tab, this.currentTab,
      {this.pushPageOnTop, this.onTabRefresh, this.openDeliveryTypesSelector});

  changeTabTo(BottomTab newBottomTab) {
    if (newBottomTab == tab && onTabRefresh != null)
      onTabRefresh();
    else {
      currentTab.value = newBottomTab;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (tab) {
      case BottomTab.catalog:
        var catalogNavigator = CatalogNavigator(
          navigatorKey: navigatorKeys[tab],
          changeTabTo: changeTabTo,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
            ],
            child: SearchWrapper(
              content: catalogNavigator,
              onBackPressed: () {
                navigatorKeys[tab].currentState.pop();
              },
              onFavouritesClick: () {
                catalogNavigator.pushFavourites(navigatorKeys[tab].currentContext);
              },
              onSearchResultClick: (searchResult) {
                catalogNavigator.pushProducts(navigatorKeys[tab].currentContext, searchResult);
              },
            ));

        break;

      case BottomTab.cart:
        var cartNavigator = CartNavigator(
          navigatorKey: navigatorKeys[tab],
          changeTabTo: changeTabTo,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
            ],
            child: SearchWrapper(
              content: cartNavigator,
              onBackPressed: () {
                navigatorKeys[tab].currentState.pop();
              },
              onFavouritesClick: () {
                cartNavigator.pushFavourites(navigatorKeys[tab].currentContext);
              },
              onSearchResultClick: (searchResult) {
                cartNavigator.pushProducts(navigatorKeys[tab].currentContext, searchResult);
              },
            ));
        break;

      case BottomTab.home:
        var homeNavigator =
            HomeNavigator(navigatorKey: navigatorKeys[tab], changeTabTo: changeTabTo);
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
            ],
            child: SearchWrapper(
              content: homeNavigator,
              onBackPressed: () {
                navigatorKeys[tab].currentState.pop();
              },
              onFavouritesClick: () {
                homeNavigator.pushFavourites(navigatorKeys[tab].currentContext);
              },
              onSearchResultClick: (searchResult) {
                homeNavigator.pushProducts(navigatorKeys[tab].currentContext, searchResult);
              },
            ));
        break;

      case BottomTab.profile:
        var profileNavigator = ProfileNavigator(
          navigatorKey: navigatorKeys[tab],
          changeTabTo: changeTabTo,
          pushPageOnTop: pushPageOnTop,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
            ],
            child: SearchWrapper(
              content: profileNavigator,
              onBackPressed: () {
                navigatorKeys[tab].currentState.pop();
              },
              onFavouritesClick: () {
                profileNavigator.pushFavourites(navigatorKeys[tab].currentContext, true);
              },
              onSearchResultClick: (searchResult) {
                profileNavigator.pushProducts(navigatorKeys[tab].currentContext, searchResult);
              },
            ));
        break;

      default:
        content = CupertinoPageScaffold(
          child: Center(
            child: Text(
              "Вкладка " + tab.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
        break;
    }

    return ValueListenableBuilder(
      valueListenable: currentTab,
      builder: (context, value, child) {
        return Offstage(
          offstage: value != tab,
          child: child,
        );
      },
      child: Material(
        child: content,
      ),
    );
  }
}
