import 'package:flutter/material.dart';
import 'package:refashioned_app/home_screen/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refashioned app',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        body: HomePage(),
      ),
    );
  }
}