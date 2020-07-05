import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/product/components/add_to_cart.dart';
import 'package:refashioned_app/screens/product/components/add_to_cart_float.dart';
import 'package:refashioned_app/screens/product/components/additional.dart';
import 'package:refashioned_app/screens/product/components/delivery.dart';
import 'package:refashioned_app/screens/product/components/description.dart';
import 'package:refashioned_app/screens/product/components/payment.dart';
import 'package:refashioned_app/screens/product/components/price.dart';
import 'package:refashioned_app/screens/product/components/questions.dart';
import 'package:refashioned_app/screens/product/components/related_products.dart';
import 'package:refashioned_app/screens/product/components/seller.dart';
import 'package:refashioned_app/screens/product/components/slider.dart';
import 'package:refashioned_app/screens/product/components/title.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            ProductSlider(),
            ProductPrice(),
            ProductTitle(),
            ProductAddToCart(),
            ProductSeller(),
            ProductDescription(),
            ProductQuestions(),
            ProductDelivery(),
            ProductPayment(),
            ProductAdditional(),
            RelatedProducts(),
            ProductAddToCartFloat()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 65,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              color: Colors.black,
              onPressed: () {},
              child: Text("КУПИТЬ СЕЙЧАС", style: TextStyle(color: Colors.white)),
            ),
            RaisedButton(
              color: Colors.amber,
              onPressed: () {},
              child: Text("В КОРЗИНУ"),
            )
          ],
        ),
      ),
    );
  }
}
