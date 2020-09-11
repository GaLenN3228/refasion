import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductPrice extends StatelessWidget {
  final Product product;

  const ProductPrice(this.product);

  @override
  Widget build(BuildContext context) {
    final currentPrice = product.currentPrice;
    final discountPrice = product.discountPrice;

    if (currentPrice == null && discountPrice == null) return SizedBox();

    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle subtitle = textTheme.subtitle1;
    TextStyle bodyText2 = textTheme.bodyText2;
    final numberFormat = NumberFormat("#,###", "ru_Ru");
    bool hasDiscount = discountPrice != null && discountPrice > 0;

    return Row(
      children: <Widget>[
        hasDiscount
            ? Text("${numberFormat.format(discountPrice)}",
                style:
                    bodyText2.copyWith(decoration: TextDecoration.lineThrough))
            : Container(),
        hasDiscount
            ? Container(
                width: 8,
              )
            : Container(),
        Container(
          color: hasDiscount ? accentColor : Color(0),
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child:
              Text("${numberFormat.format(currentPrice)} ₽", style: subtitle),
        )
      ],
    );
  }
}
