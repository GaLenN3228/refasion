import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductPrice extends StatelessWidget {
  final Product product;

  const ProductPrice({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPrice = product?.currentPrice;
    final discountPrice = product?.discountPrice;

    if (currentPrice == null) return SizedBox();

    final numberFormat = NumberFormat("#,###", "ru_Ru");
    final hasDiscount = discountPrice != null && discountPrice > 0;

    return Row(
      children: <Widget>[
        hasDiscount
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  "${numberFormat.format(discountPrice)}",
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              )
            : SizedBox(),
        Container(
          color: hasDiscount ? accentColor : null,
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: Text(
            "${numberFormat.format(currentPrice)} ₽",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        )
      ],
    );
  }
}
