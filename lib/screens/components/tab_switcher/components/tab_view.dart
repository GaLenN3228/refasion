import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/cart/cart/cart_navigator.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
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

    if (currentTab != newTab)
      setState(() => currentTab = newTab);
    else {
      final canPop = navigatorKeys[currentTab]?.currentState?.canPop() ?? false;

      print(canPop);

      if (canPop)
        navigatorKeys[currentTab]
            .currentState
            .pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  void dispose() {
    widget.currentTab?.removeListener(tabListener);

    super.dispose();
  }

  changeTabTo(BottomTab newBottomTab) {
    widget.currentTab.value = newBottomTab;
    widget.currentTab.notifyListeners();
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

    return Offstage(
      offstage: currentTab != widget.tab,
      child: CupertinoPageScaffold(
        child: content,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
