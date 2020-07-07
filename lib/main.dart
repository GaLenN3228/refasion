import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_page.dart';
import 'package:refashioned_app/screens/product/pages/product.dart';
import 'package:refashioned_app/utils/colors.dart';

void main() => runApp(RefashionApp());

class RefashionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CatalogRepository>(create: (_) => CatalogRepository()),
          ChangeNotifierProvider<ProductsRepository>(create: (_) => ProductsRepository())
        ],
        child: MaterialApp(
          theme: _materialTheme(),
          debugShowCheckedModeBanner: false,
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: ProductPage(),
          ),
        ));
  }
}

ThemeData _materialTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 16,
            fontFamily: "SF UI",
            color: primaryColor,
            height: 1.2,
            fontWeight: FontWeight.w600),
        headline2: TextStyle(
            fontSize: 16,
            fontFamily: "SF UI",
            color: primaryColor,
            fontWeight: FontWeight.w600,
            height: 1.2),
        bodyText1: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI",
            color: primaryColor,
            fontWeight: FontWeight.normal,
            height: 1.5),
        bodyText2: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI",
            color: darkGrayColor,
            fontWeight: FontWeight.normal,
            height: 1.2),
        subtitle1: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI",
            fontWeight: FontWeight.w600,
            color: primaryColor,
            height: 1.2),
        subtitle2: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI",
            fontWeight: FontWeight.normal,
            color: darkGrayColor,
            height: 1.6),
        caption: TextStyle(
            fontSize: 10,
            fontFamily: "SF UI",
            fontWeight: FontWeight.normal,
            color: darkGrayColor,
            height: 1.2),
        button: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI",
            fontWeight: FontWeight.w600,
            color: primaryColor,
            height: 1.2),
      ));
}
