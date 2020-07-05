import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/catalog/pages/catalog_page.dart';

void main() => runApp(RefashionApp());

class RefashionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CatalogRepository>(create: (_) => CatalogRepository()),
          ChangeNotifierProvider<ProductRepository>(create: (_) => ProductRepository())
        ],
        child: MaterialApp(
          theme: _materialTheme(),
          debugShowCheckedModeBanner: false,
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: CatalogPage(),
          ),
        ));
  }
}

ThemeData _materialTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 16, fontFamily: "SF UI", color: Colors.grey),
        headline2: TextStyle(
            fontSize: 12, fontFamily: "SF UI", fontWeight: FontWeight.w500, color: Colors.black),
      ));
}