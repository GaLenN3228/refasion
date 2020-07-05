import 'package:flutter/material.dart';

class ProductAdditionalButton extends StatelessWidget {
  final String text;

  const ProductAdditionalButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text(text), Icon(Icons.keyboard_arrow_right)],
    );
  }
}
