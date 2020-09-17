import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/repositories/user_addresses.dart';
import 'package:refashioned_app/screens/cart/cart_navigator.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/home/home_navigator.dart';
import 'package:refashioned_app/screens/profile/profile_navigator.dart';
import 'package:refashioned_app/screens/search_wrapper.dart';
import 'package:refashioned_app/screens/delivery/components/delivery_options_panel.dart';
import 'package:refashioned_app/screens/delivery/delivery_navigator.dart';

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

  TabView(this.tab, this.currentTab, {this.pushPageOnTop, this.onTabRefresh});

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  bool selected = false;

  changeTabTo(BottomTab newBottomTab) {
    if (newBottomTab == widget.tab && widget.onTabRefresh != null)
      widget.onTabRefresh();
    else {
      widget.currentTab.value = newBottomTab;
    }
  }

  openDeliveryTypesSelector(
    BuildContext context,
    String id, {
    List<DeliveryType> deliveryTypes,
    PickPoint pickUpAddress,
    Function() onClose,
    Function(String, String) onFinish,
  }) async {
    List<DeliveryType> types;
    List<UserAddress> userAddresses;

    if (deliveryTypes == null || deliveryTypes.isEmpty) {
      final deliveryTypesRepository =
          Provider.of<CartRepository>(context, listen: false);

      await deliveryTypesRepository.getCartItemDeliveryTypes(id);

      types = deliveryTypesRepository?.getDeliveryTypes?.response?.content;
    } else {
      types = deliveryTypes;
    }

    final userAddressesRepository = GetUserAddressesRepository();

    await userAddressesRepository.update();

    userAddresses = userAddressesRepository.response?.content ?? [];

    if (types != null && types.isNotEmpty)
      await showMaterialModalBottomSheet(
        expand: false,
        context: context,
        useRootNavigator: true,
        builder: (context, controller) => DeliveryOptionsPanel(
          onPush: (deliveryType) {
            selected = true;

            Navigator.of(context).pop();

            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SlideTransition(
                  position: Tween(begin: Offset(0, 1), end: Offset.zero)
                      .animate(animation),
                  child: DeliveryNavigator(
                    deliveryType: deliveryType,
                    pickUpAddress: pickUpAddress,
                    userAddresses: userAddresses,
                    onClose: () async {
                      await onClose?.call();
                      userAddressesRepository.dispose();

                      Navigator.of(context).pop();
                    },
                    onFinish: (id) async {
                      await onFinish?.call(deliveryType.items.first.id, id);
                      userAddressesRepository.dispose();

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            );
          },
          options: types,
        ),
      );

    if (!selected) onClose?.call();

    selected = false;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (widget.tab) {
      case BottomTab.catalog:
        var catalogNavigator = CatalogNavigator(
          navigatorKey: navigatorKeys[widget.tab],
          changeTabTo: changeTabTo,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(
                  create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(
                  create: (_) => SearchRepository()),
            ],
            child: SearchWrapper(
              content: catalogNavigator,
              onBackPressed: () {
                navigatorKeys[widget.tab].currentState.pop();
              },
              onFavouritesClick: () {
                catalogNavigator
                    .pushFavourites(navigatorKeys[widget.tab].currentContext);
              },
              onSearchResultClick: (searchResult) {
                catalogNavigator.pushProducts(
                    navigatorKeys[widget.tab].currentContext, searchResult);
              },
            ));

        break;

      case BottomTab.cart:
        content = CartNavigator(
          navigatorKey: navigatorKeys[widget.tab],
          changeTabTo: changeTabTo,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
        );
        break;

      case BottomTab.home:
        var homeNavigator = HomeNavigator(
            navigatorKey: navigatorKeys[widget.tab], changeTabTo: changeTabTo);
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(
                  create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(
                  create: (_) => SearchRepository()),
            ],
            child: SearchWrapper(
              content: homeNavigator,
              onBackPressed: () {
                navigatorKeys[widget.tab].currentState.pop();
              },
              onFavouritesClick: () {
                homeNavigator
                    .pushFavourites(navigatorKeys[widget.tab].currentContext);
              },
              onSearchResultClick: (searchResult) {
                homeNavigator.pushProducts(
                    navigatorKeys[widget.tab].currentContext, searchResult);
              },
            ));
        break;

      case BottomTab.profile:
        var profileNavigator = ProfileNavigator(
          navigatorKey: navigatorKeys[widget.tab],
          changeTabTo: changeTabTo,
          pushPageOnTop: widget.pushPageOnTop,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(
                  create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(
                  create: (_) => SearchRepository()),
            ],
            child: SearchWrapper(
              content: profileNavigator,
              onBackPressed: () {
                navigatorKeys[widget.tab].currentState.pop();
              },
              onFavouritesClick: () {
                profileNavigator.pushFavourites(
                    navigatorKeys[widget.tab].currentContext, true);
              },
              onSearchResultClick: (searchResult) {
                profileNavigator.pushProducts(
                    navigatorKeys[widget.tab].currentContext, searchResult);
              },
            ));
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
