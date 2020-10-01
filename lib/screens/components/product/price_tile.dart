import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductPriceTile extends StatelessWidget {
  final Product product;

  const ProductPriceTile({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final regularPrice = product?.currentPrice;
    final discountPrice = product?.discountPrice;

    if (regularPrice == null) return SizedBox();

    final numberFormat = NumberFormat("#,###", "ru_Ru");
    final hasDiscount = discountPrice != null && discountPrice > 0;

    if (!hasDiscount)
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          "${numberFormat.format(regularPrice)} ₽",
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                height: 1.0,
              ),
        ),
      );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              "${numberFormat.format(regularPrice)}",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: darkGrayColor,
                    height: 1.0,
                  ),
            ),
          ),
          Container(
            color: accentColor,
            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            child: Text(
              "${numberFormat.format(discountPrice)} ₽",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    height: 1.0,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
