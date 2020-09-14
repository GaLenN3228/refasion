import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/screens/cart/cart/cart_navigator.dart';
import 'package:refashioned_app/screens/cart/delivery/delivery_navigator.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_wrapper_page.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/home/home.dart';
import 'package:refashioned_app/screens/profile/profile.dart';

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
  final Function() onTabRefresh;
  final CatalogNavigator catalogNavigator;

  TabView(this.tab, this.currentTab, {this.pushPageOnTop, this.onTabRefresh, this.catalogNavigator});

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  changeTabTo(BottomTab newBottomTab) {
    if (newBottomTab == widget.tab && widget.onTabRefresh != null)
      widget.onTabRefresh();
    else {
      widget.currentTab.value = newBottomTab;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (widget.tab) {
      case BottomTab.catalog:
        widget.catalogNavigator.navigatorKey = navigatorKeys[widget.currentTab.value];
        widget.catalogNavigator.changeTabTo = changeTabTo;
        content = widget.catalogNavigator;
        break;

      case BottomTab.cart:
        content = CartNavigator(
          navigatorKey: navigatorKeys[widget.tab],
          changeTabTo: changeTabTo,
          pushDeliveryNavigator: (deliveryType, pickUpAddress, onPickUpAddressAccept) {
            if (deliveryType != null && (pickUpAddress != null || deliveryType != DeliveryType.PICKUP_ADDRESS))
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
                    position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(animation),
                    child: DeliveryNavigator(
                      deliveryType: deliveryType,
                      pickUpAddress: pickUpAddress,
                      onClose: Navigator.of(context).pop,
                      onAcceptPickUpAddress: () {
                        Navigator.of(context).pop();
                        onPickUpAddressAccept();
                      },
                    ),
                  ),
                ),
              );
          },
        );
        break;

      case BottomTab.home:
        content = CupertinoPageScaffold(
          child: HomePage(),
        );
        break;

      case BottomTab.profile:
        content = CupertinoPageScaffold(
          child: ProfilePage(catalogNavigator: widget.catalogNavigator, currentTab: widget.currentTab,),
        );
        break;

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

    return ValueListenableBuilder(
      valueListenable: widget.currentTab,
      builder: (context, value, child) {
        var topPanelController = Provider.of<TopPanelController>(context, listen: false);
        switch (widget.currentTab.value){
          case BottomTab.cart:
            topPanelController.needShow = false;
            break;
          case BottomTab.home:
            topPanelController.needShow = true;
            break;
          case BottomTab.catalog:
            topPanelController.needShow = true;
            break;
          case BottomTab.profile:
            topPanelController.needShow = false;
            break;
        }
        return Offstage(
          offstage: value != widget.tab,
          child: child,
        );
      },
      child: Material(
        child: content,
      ),
    );
  }
}
