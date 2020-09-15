import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/cart/cart_navigator.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_wrapper_page.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/delivery/components/delivery_options_panel.dart';
import 'package:refashioned_app/screens/delivery/delivery_navigator.dart';
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

  const TabView(this.tab, this.currentTab,
      {this.pushPageOnTop, this.onTabRefresh});

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  bool selected = false;

  changeTabTo(BottomTab newBottomTab) {
    if (newBottomTab == widget.tab && widget.onTabRefresh != null)
      widget.onTabRefresh();
    else
      widget.currentTab.value = newBottomTab;
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

    if (deliveryTypes == null || deliveryTypes.isEmpty) {
      final repository = Provider.of<CartRepository>(context, listen: false);

      await repository.getCartItemDeliveryTypes(id);

      types = repository?.getDeliveryTypes?.response?.content;
    } else {
      types = deliveryTypes;
    }

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
                    onClose: () {
                      Navigator.of(context).pop();
                      onClose?.call();
                    },
                    onFinish: (id) {
                      Navigator.of(context).pop();
                      onFinish?.call(deliveryType.items.first.id, id);
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
          navigatorKey: navigatorKeys[widget.currentTab.value],
          changeTabTo: changeTabTo,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<SearchRepository>(
                  create: (_) => SearchRepository()),
              ChangeNotifierProvider<TopPanelController>(
                  create: (_) => TopPanelController())
            ],
            builder: (context, _) {
              var topPanelController =
                  Provider.of<TopPanelController>(context, listen: false);
              return CatalogWrapperPage(
                catalogNavigator: catalogNavigator,
                onFavClick: () {},
                navigatorKey: navigatorKeys[widget.currentTab.value],
              );
            });
        break;

      case BottomTab.cart:
        content = CartNavigator(
          navigatorKey: navigatorKeys[widget.tab],
          changeTabTo: changeTabTo,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
        );
        break;

      case BottomTab.home:
        content = CupertinoPageScaffold(
          child: HomePage(),
        );
        break;

      case BottomTab.profile:
        content = CupertinoPageScaffold(
          child: ProfilePage(),
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
