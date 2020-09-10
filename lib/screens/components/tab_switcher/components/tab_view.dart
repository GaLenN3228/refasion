import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/screens/cart/cart/cart_navigator.dart';
import 'package:refashioned_app/screens/cart/delivery/delivery_navigator.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';

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

  const TabView(this.tab, this.currentTab,
      {this.pushPageOnTop, this.onTabRefresh});

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  changeTabTo(BottomTab newBottomTab) {
    if (newBottomTab == widget.tab && widget.onTabRefresh != null)
      widget.onTabRefresh();
    else
      widget.currentTab.value = newBottomTab;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (widget.tab) {
      case BottomTab.catalog:
        content = CatalogNavigator(
          navigatorKey: navigatorKeys[widget.tab],
          onPushPageOnTop: widget.pushPageOnTop,
          changeTabTo: changeTabTo,
        );
        break;

      case BottomTab.cart:
        content = CartNavigator(
          navigatorKey: navigatorKeys[widget.tab],
          changeTabTo: changeTabTo,
          pushDeliveryNavigator:
              (deliveryType, pickUpAddress, onPickUpAddressAccept) {
            if (deliveryType != null &&
                (pickUpAddress != null ||
                    deliveryType != DeliveryType.PICKUP_ADDRESS))
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SlideTransition(
                    position: Tween(begin: Offset(0, 1), end: Offset.zero)
                        .animate(animation),
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

    return ValueListenableBuilder(
      valueListenable: widget.currentTab,
      builder: (context, value, child) => Offstage(
        offstage: value != widget.tab,
        child: child,
      ),
      child: CupertinoPageScaffold(
        child: content,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
