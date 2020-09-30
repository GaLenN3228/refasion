import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/authorization.dart';
import 'package:refashioned_app/repositories/cart/cart.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/repositories/filters.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/screens/city_selector/city_selector.dart';
import 'package:refashioned_app/screens/onbording/on_bording.dart';
import 'package:refashioned_app/utils/colors.dart';

void main() => runApp(RefashionApp());

class RefashionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CatalogRepository>(
            create: (_) => CatalogRepository()..getCatalog(),
          ),
          ChangeNotifierProvider<CitiesRepository>(
            create: (_) => CitiesRepository(),
          ),
          ChangeNotifierProvider<CartRepository>(
            create: (_) => CartRepository(),
          ),
          ChangeNotifierProvider<CodeAuthorizationRepository>(
            create: (_) => CodeAuthorizationRepository(),
          ),
          ChangeNotifierProvider<FiltersRepository>(
            create: (_) => FiltersRepository(),
          ),
          Provider<SizesProvider>(
            create: (_) => SizesProvider(),
          ),
        ],
        child: MaterialApp(
          theme: _materialTheme(),
          debugShowCheckedModeBanner: false,
          home: OnboardingPage(),
        ));
  }
}

ThemeData _materialTheme() {
  return ThemeData(
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 16,
            fontFamily: "SF UI Text",
            color: primaryColor,
            height: 1.2,
            fontWeight: FontWeight.w600),
        headline2: TextStyle(
            fontSize: 16,
            fontFamily: "SF UI Text",
            color: primaryColor,
            fontWeight: FontWeight.w600,
            height: 1.2),
        headline3: TextStyle(
          fontSize: 28,
          fontFamily: "SF UI Text",
          color: white,
          fontWeight: FontWeight.w600,
        ),
        headline5: TextStyle(
            fontSize: 16,
            fontFamily: "SF UI Text",
            color: primaryColor,
            fontWeight: FontWeight.normal,
            height: 1.2),
        headline6: TextStyle(
            fontSize: 16,
            fontFamily: "SF UI Text",
            color: primaryColor,
            fontWeight: FontWeight.w600,
            height: 1.2),
        bodyText1: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI Text",
            color: primaryColor,
            fontWeight: FontWeight.normal,
            height: 1.5),
        bodyText2: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI Text",
            color: darkGrayColor,
            fontWeight: FontWeight.normal,
            height: 1.2),
        subtitle1: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI Text",
            fontWeight: FontWeight.w600,
            color: primaryColor,
            height: 1.2),
        subtitle2: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI Text",
            fontWeight: FontWeight.normal,
            color: darkGrayColor,
            height: 1.6),
        caption: TextStyle(
            fontSize: 10,
            fontFamily: "SF UI Text",
            fontWeight: FontWeight.normal,
            color: darkGrayColor,
            height: 1.2),
        button: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI Text",
            fontWeight: FontWeight.w600,
            color: primaryColor,
            height: 1.2),
      ));
}
