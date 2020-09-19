import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';

class ProductTitle extends StatelessWidget {
  final Product product;

  const ProductTitle({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = product?.name;
    final brand = product?.brand?.name;

    if (name == null && brand == null) return SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name != null && name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 2.5),
              child: Text(
                name,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          if (brand != null && brand.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2.5),
              child: Text(
                brand,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            )
        ],
      ),
    );
  }
}
