import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/home.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/cart/cart_navigator.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:refashioned_app/screens/home/home_navigator.dart';
import 'package:refashioned_app/screens/profile/components/user_photo_controller.dart';
import 'package:refashioned_app/screens/profile/profile_navigator.dart';
import 'package:refashioned_app/screens/search_wrapper.dart';

class TabView extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomTab tab;
  final ValueNotifier<BottomTab> currentTab;
  final Function(Widget) pushPageOnTop;
  final Function(PickPoint) openPickUpAddressMap;
  final Function(String url, String title) openInfoWebViewBottomSheet;

  final Function() onTabRefresh;
  final Function(Order, Function()) onCheckoutPush;
  final Function(Seller, Function()) onSellerReviewsPush;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function() onFinish,
    Future<bool> Function(String, String) onSelect,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  const TabView(
    this.tab,
    this.currentTab, {
    this.pushPageOnTop,
    this.onTabRefresh,
    this.openDeliveryTypesSelector,
    this.openPickUpAddressMap,
    this.onCheckoutPush,
    this.navigatorKey,
    this.openInfoWebViewBottomSheet,
    this.onSellerReviewsPush,
  });

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
          navigatorKey: navigatorKey,
          changeTabTo: changeTabTo,
          openPickUpAddressMap: openPickUpAddressMap,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
          onCheckoutPush: onCheckoutPush,
          onSellerReviewsPush: onSellerReviewsPush,
          openInfoWebViewBottomSheet: openInfoWebViewBottomSheet,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
              ChangeNotifierProvider<CategoryBrandsRepository>(create: (_) => CategoryBrandsRepository()),
            ],
            child: SearchWrapper(
              content: catalogNavigator,
              onBackPressed: () {
                navigatorKey.currentState.pop();
              },
              onFavouritesClick: () {
                catalogNavigator.pushFavourites(navigatorKey.currentContext);
              },
              onSearchResultClick: (searchResult) {
                catalogNavigator.pushProducts(navigatorKey.currentContext, searchResult);
              },
            ));

        break;

      case BottomTab.cart:
        var cartNavigator = CartNavigator(
          navigatorKey: navigatorKey,
          changeTabTo: changeTabTo,
          openPickUpAddressMap: openPickUpAddressMap,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
          onCheckoutPush: onCheckoutPush,
          onSellerReviewsPush: onSellerReviewsPush,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
              ChangeNotifierProvider<CategoryBrandsRepository>(create: (_) => CategoryBrandsRepository())
            ],
            child: SearchWrapper(
              content: cartNavigator,
              onBackPressed: () {
                navigatorKey.currentState.pop();
              },
              onFavouritesClick: () {
                cartNavigator.pushFavourites(navigatorKey.currentContext);
              },
              onSearchResultClick: (searchResult) {
                cartNavigator.pushProducts(navigatorKey.currentContext, searchResult);
              },
            ));
        break;

      case BottomTab.home:
        var homeNavigator = HomeNavigator(
          navigatorKey: navigatorKey,
          openPickUpAddressMap: openPickUpAddressMap,
          changeTabTo: changeTabTo,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
          onCheckoutPush: onCheckoutPush,
          onSellerReviewsPush: onSellerReviewsPush,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
              ChangeNotifierProvider<HomeRepository>(create: (_) => HomeRepository()..getHomePage()),
              ChangeNotifierProvider<CategoryBrandsRepository>(create: (_) => CategoryBrandsRepository())
            ],
            child: SearchWrapper(
              content: homeNavigator,
              onBackPressed: () {
                navigatorKey.currentState.pop();
              },
              onFavouritesClick: () {
                homeNavigator.pushFavourites(navigatorKey.currentContext);
              },
              onSearchResultClick: (searchResult) {
                homeNavigator.pushProducts(navigatorKey.currentContext, searchResult);
              },
            ));
        break;

      case BottomTab.profile:
        var profileNavigator = ProfileNavigator(
          navigatorKey: navigatorKey,
          changeTabTo: changeTabTo,
          pushPageOnTop: pushPageOnTop,
          openPickUpAddressMap: openPickUpAddressMap,
          openDeliveryTypesSelector: openDeliveryTypesSelector,
          onCheckoutPush: onCheckoutPush,
          onSellerReviewsPush: onSellerReviewsPush,
        );
        content = MultiProvider(
            providers: [
              ChangeNotifierProvider<TopPanelController>(create: (_) => TopPanelController()),
              ChangeNotifierProvider<SearchRepository>(create: (_) => SearchRepository()),
              ChangeNotifierProvider<CategoryBrandsRepository>(create: (_) => CategoryBrandsRepository()),
              ChangeNotifierProvider<UserPhotoController>(create: (_) => UserPhotoController()),
            ],
            child: SearchWrapper(
              content: profileNavigator,
              onBackPressed: () {
                navigatorKey.currentState.pop();
              },
              onFavouritesClick: () {
                profileNavigator.pushFavourites(navigatorKey.currentContext, true);
              },
              onSearchResultClick: (searchResult) {
                profileNavigator.pushProducts(navigatorKey.currentContext, searchResult);
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
