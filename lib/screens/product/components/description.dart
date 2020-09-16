import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/product/components/properties.dart';

class ProductDescription extends StatelessWidget {
  final Product product;

  const ProductDescription({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product.description == null &&
        product.article == null &&
        product.properties == null) return SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (product.description != null && product.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                product.description,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ProductProperties(
            product: product,
          ),
        ],
      ),
    );
  }
}
