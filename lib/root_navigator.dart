import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/repositories/authorization.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/repositories/onboarding.dart';
import 'package:refashioned_app/screens/authorization/authorization_sheet.dart';
import 'package:refashioned_app/screens/authorization/code_page.dart';
import 'package:refashioned_app/screens/authorization/name_page.dart';
import 'package:refashioned_app/screens/authorization/phone_page.dart';
import 'package:refashioned_app/screens/checkout/checkout_navigator.dart';
import 'package:refashioned_app/screens/city_selector/city_selector.dart';
import 'package:refashioned_app/screens/city_selector/splash_screen.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/tab_switcher/tab_switcher.dart';
import 'package:refashioned_app/screens/onbording/on_bording.dart';
import 'package:refashioned_app/screens/seller/pages/select_seller_rating.dart';
import 'package:refashioned_app/screens/seller/pages/seller_reviews.dart';
import 'package:refashioned_app/screens/seller/pages/send_seller_review.dart';
import 'models/seller.dart';

class RootNavigatorRoutes {
  static const String splashScreen = '/splash_screen';
  static const String citySelector = '/city_selector';
  static const String onboarding = '/onboarding';
  static const String authPhone = '/auth_phone';
  static const String authCode = '/auth_code';
  static const String authName = '/auth_name';
  static const String tabs = '/tabs';
  static const String deliverySelector = '/delivery_selector';
  static const String checkout = '/checkout';
  static const String sellerReviews = '/seller_reviews';
  static const String selectSellerRating = '/select_seller_rating';
  static const String sendSellerReview = '/send_seller_review';
}

class RootNavigatorObserver extends NavigatorObserver {
  final Function() onReturnToTabs;

  RootNavigatorObserver({this.onReturnToTabs});

  @override
  void didPop(Route route, Route previousRoute) {
    switch (previousRoute?.settings?.name) {
      case RootNavigatorRoutes.tabs:
        onReturnToTabs?.call();
        break;

      default:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
    }

    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    switch (route?.settings?.name) {
      default:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
    }
    super.didPush(route, previousRoute);
  }
}

class RootNavigator extends StatefulWidget {
  @override
  _CheckoutNavigatorState createState() => _CheckoutNavigatorState();
}

class _CheckoutNavigatorState extends State<RootNavigator> {
  CitiesRepository citiesRepository;
  ValueNotifier<BottomTab> currentTab;

  Order order;
  Function() onReturnToTabs;
  Function(String) onPush;

  Seller seller;
  int rating;
  String phone;

  @override
  initState() {
    citiesRepository = Provider.of<CitiesRepository>(context, listen: false);
    citiesRepository.addListener(citiesRepositoryListener);
    currentTab = ValueNotifier(BottomTab.catalog);

    super.initState();
  }

  @override
  dispose() {
    citiesRepository.removeListener(citiesRepositoryListener);

    currentTab.dispose();

    super.dispose();
  }

  citiesRepositoryListener() async {
    String nextRoute = RootNavigatorRoutes.tabs;

    if (citiesRepository.isLoaded &&
        citiesRepository.response.content != null &&
        !citiesRepository.response.content.skipable) {
      nextRoute = RootNavigatorRoutes.citySelector;
    }

    citiesRepository.removeListener(citiesRepositoryListener);

    await Future.delayed(Duration(milliseconds: 400));

    onPush(nextRoute);
  }

  Widget _routeBuilder(BuildContext context, String route) {
    switch (route) {
      case RootNavigatorRoutes.splashScreen:
        onPush = (nextRoute) => Navigator.of(context).pushReplacementNamed(nextRoute);
        return SplashScreen();

      case RootNavigatorRoutes.citySelector:
        return CitySelector(
          onFirstLaunch: true,
          onPush: () => Navigator.of(context).pushReplacementNamed(RootNavigatorRoutes.onboarding),
        );

      case RootNavigatorRoutes.tabs:
        return TabSwitcher(
          currentTab: currentTab,
          onCheckoutPush: (Order newOrder, Function() callback) {
            order = newOrder;
            onReturnToTabs = callback;
            Navigator.of(context).pushNamed(RootNavigatorRoutes.checkout);
          },
          onSellerReviewsPush: (Seller newSeller, Function() callback) {
            seller = newSeller;
            onReturnToTabs = callback;
            Navigator.of(context).pushNamed(RootNavigatorRoutes.sellerReviews);
          },
        );

      case RootNavigatorRoutes.onboarding:
        return OnboardingPage(
          onPush: () => Navigator.of(context).pushReplacementNamed(RootNavigatorRoutes.authPhone),
        );

      case RootNavigatorRoutes.authPhone:
        return KeyboardVisibilityProvider(
          child: PhonePage(
            needDismiss: false,
            onPush: (String newPhone) {
              phone = newPhone;
              Navigator.of(context).pushNamed(RootNavigatorRoutes.authCode);
            },
            onAuthorizationCancel: (_) => Navigator.of(context).pushNamedAndRemoveUntil(
              RootNavigatorRoutes.tabs,
              (route) => false,
            ),
          ),
        );

      case RootNavigatorRoutes.authCode:
        return ChangeNotifierProvider<AuthorizationRepository>(
          create: (_) => AuthorizationRepository()..sendPhoneAndGetCode(phone),
          child: KeyboardVisibilityProvider(
            child: CodePage(
              phone: phone,
              needDismiss: false,
              onPush: () => Navigator.of(context).pushNamed(RootNavigatorRoutes.authName),
              onAuthorizationCancel: (_) => Navigator.of(context).pushNamedAndRemoveUntil(
                RootNavigatorRoutes.tabs,
                (route) => false,
              ),
            ),
          ),
        );

      case RootNavigatorRoutes.authName:
        return KeyboardVisibilityProvider(
          child: NamePage(
            needDismiss: false,
            onAuthorizationDone: (_) => Navigator.of(context).pushNamedAndRemoveUntil(
              RootNavigatorRoutes.tabs,
              (route) => false,
            ),
          ),
        );

      case RootNavigatorRoutes.checkout:
        return CheckoutNavigator(
          order: order,
          changeTabTo: (BottomTab newTab) => currentTab.value = newTab,
          onClose: Navigator.of(context).pop,
        );

      case RootNavigatorRoutes.sellerReviews:
        return SellerReviewsPage(
          seller: seller,
          onAddSellerRatingPush: () async {
            if (!await BaseRepository.isAuthorized()) {
              await showMaterialModalBottomSheet(
                expand: false,
                context: context,
                useRootNavigator: true,
                builder: (__, controller) => AuthorizationSheet(
                  onAuthorizationCancel: (_) => {},
                  onAuthorizationDone: (_) => Navigator.of(context).pushNamed(RootNavigatorRoutes.selectSellerRating),
                ),
              );
            } else
              return Navigator.of(context).pushNamed(RootNavigatorRoutes.selectSellerRating);
          },
        );

      case RootNavigatorRoutes.selectSellerRating:
        return SelectSellerRatingPage(
          seller: seller,
          onAddSellerReviewPush: (int newRating) {
            rating = newRating;
            Navigator.of(context).pushNamed(RootNavigatorRoutes.sendSellerReview);
          },
        );

      case RootNavigatorRoutes.sendSellerReview:
        return SendSellerReviewPage(
          seller: seller,
          rating: rating,
          onPush: () => Navigator.of(context).pushNamedAndRemoveUntil(
            RootNavigatorRoutes.sellerReviews,
            (route) => route.settings.name == RootNavigatorRoutes.tabs,
          ),
        );

      default:
        return CupertinoPageScaffold(
          backgroundColor: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Unexpected route:",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$route",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Navigator(
        initialRoute: RootNavigatorRoutes.splashScreen,
        observers: [
          RootNavigatorObserver(
            onReturnToTabs: () => onReturnToTabs?.call(),
          ),
        ],
        onGenerateInitialRoutes: (navigatorState, initialRoute) => [
          CupertinoPageRoute(
            builder: (context) => _routeBuilder(
              context,
              initialRoute,
            ),
            settings: RouteSettings(
              name: initialRoute,
            ),
          ),
        ],
        onGenerateRoute: (routeSettings) => CupertinoPageRoute(
          builder: (context) => _routeBuilder(
            context,
            routeSettings.name,
          ),
          settings: routeSettings,
        ),
      );
}
