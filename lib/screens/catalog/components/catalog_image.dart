import 'package:flutter/material.dart';

class CatalogImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/dresses.png',
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
