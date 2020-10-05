import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductSizeTile extends StatelessWidget {
  final Product product;

  const ProductSizeTile({this.product});

  @override
  Widget build(BuildContext context) {
    final size = product.properties.firstWhere((element) => element.property == "size", orElse: () => null)?.value;

    if (size == null) return SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: "Размер: ",
          children: [
            TextSpan(
              text: size,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: primaryColor,
                    height: 1.0,
                  ),
            ),
          ],
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                height: 1.0,
              ),
        ),
      ),
    );
  }
}
