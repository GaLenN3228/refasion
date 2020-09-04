import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';

class ProductBrand extends StatelessWidget {
  final Product product;

  const ProductBrand(this.product);

  @override
  Widget build(BuildContext context) {
    final brand = product?.brand?.name;

    if (brand == null) return SizedBox();

    return Text(
      brand,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}
