import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/product/components/price.dart';
import 'package:refashioned_app/screens/product/components/properties.dart';
import 'package:refashioned_app/utils/colors.dart';

class CartProduct extends StatelessWidget {
  final Product product;

  const CartProduct(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: lightGrayColor,
        ))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 7.0, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: lightGrayColor,
              ),
              child: Image.network(
                product.image != null ? product.image :
                "https://admin.refashioned.ru/media/product/2c8cb353-4feb-427d-9279-d2b75f46d786/2b22b56279182fe9bedb1f246d9b44b7.JPG",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  ),
                  ProductProperties(
                    properties: product.properties.length < 4 ? product.properties : product.properties.sublist(0,3),
                    article: product.article,
                    hasDots: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ProductPrice(
                          currentPrice: product.currentPrice,
                          discountPrice: product.discountPrice,
                        ),
                        Button(
                          "Купить",
                          buttonStyle: ButtonStyle.outline,
                          width: 80,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
