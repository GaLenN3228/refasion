import 'package:flutter/material.dart';
import 'package:refashioned_app/components/button.dart';

class ProductAddToCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Button(
      "Добавить в корзину",
      buttonStyle: ButtonStyle.dark,
      height: 45,
      borderRadius: 5,
    );
  }
}
