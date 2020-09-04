import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductSize extends StatelessWidget {
  final Product product;

  const ProductSize(this.product);

  @override
  Widget build(BuildContext context) {
    final size = product.properties
        .firstWhere((element) => element.property == "size", orElse: () => null)
        ?.value;

    if (size == null) return SizedBox();

    return RichText(
      text: TextSpan(
        text: "Размер: ",
        children: [
          TextSpan(
            text: size,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: primaryColor),
          ),
        ],
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
