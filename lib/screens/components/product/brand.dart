import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';

class ProductBrandTile extends StatelessWidget {
  final Product product;

  const ProductBrandTile({this.product});

  @override
  Widget build(BuildContext context) {
    final brand = product?.brand?.name;

    if (brand == null) return SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        brand,
        style: Theme.of(context).textTheme.subtitle2.copyWith(height: 1.0),
      ),
    );
  }
}
