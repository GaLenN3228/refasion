import 'package:flutter/material.dart';

class ProductAddToCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text("ДОБАВИТЬ В КОРЗИНУ",
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
