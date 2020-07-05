import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_page.dart';
import 'package:refashioned_app/screens/product/pages/product.dart';

void main() => runApp(ChangeNotifierProvider<CatalogRepository>(
      create: (_) => CatalogRepository(),
      child: RefashionApp(),
    ));

class RefashionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _materialTheme(),
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ProductPage(),
      ),
    );
  }
}

ThemeData _materialTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        headline1:
            TextStyle(fontSize: 16, fontFamily: "SF UI", color: Colors.grey),
        bodyText1:TextStyle(
            fontSize: 12,
            fontFamily: "SF UI", ),
        headline2: TextStyle(
            fontSize: 12,
            fontFamily: "SF UI",
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ));
}
