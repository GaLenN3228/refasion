import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/product/components/additional_button.dart';

class ProductAdditional extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ProductAdditionalButton("Все вещи этого продавца"),
        ProductAdditionalButton("Все платья бренда O’STIN"),
        ProductAdditionalButton("Все платья свободного кроя"),
        ProductAdditionalButton("Все платья"),
      ],
    );
  }
}
