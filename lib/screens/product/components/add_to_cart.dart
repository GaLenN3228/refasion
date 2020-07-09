import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button.dart';

class ProductAddToCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Button(
      "Добавить в корзину",
      buttonStyle: ButtonStyle.dark,
      height: 45,
      width: double.infinity,
      borderRadius: 5,
    );
  }
}
