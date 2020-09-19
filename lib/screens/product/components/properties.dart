import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/property.dart';
import 'package:refashioned_app/screens/product/components/product_property_tile.dart';

class ProductProperties extends StatelessWidget {
  final Product product;

  const ProductProperties({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (product.article != null && product.article.isNotEmpty)
          Property(
            property: "Артикул",
            value: product.article,
          ),
        if (product.properties != null) ...product.properties,
      ]
          .map(
            (property) => ProductPropertyTile(
              property: property,
            ),
          )
          .toList(),
    );
  }
}
