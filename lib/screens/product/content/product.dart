import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/productDemo.dart';
import 'package:refashioned_app/screens/product/components/add_to_cart.dart';
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

class ProductPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductRepositoryDemo productRepository = context.watch<ProductRepositoryDemo>();
    print(productRepository.productResponse);
    if (productRepository.isLoading)
      return Center(
        child: Text("Загрузка"),
      );

    if (productRepository.loadingFailed)
      return Center(
        child: Text("Ошибкаs"),
      );

    if (productRepository.productResponse.status.code != 200)
      return Center(
        child: Text("Иной статус"),
      );
    return ListView(
      children: <Widget>[
        ProductSlider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
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
            ],
          ),
        ),
      ],
    );
  }
}
