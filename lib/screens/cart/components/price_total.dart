import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';

class CartPriceTotal extends StatelessWidget {
  final num discountPriceAmount;
  final num currentPriceAmount;

  const CartPriceTotal(
      {@required this.discountPriceAmount, @required this.currentPriceAmount});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle textStyle = textTheme.bodyText2.copyWith(height: 2);
    final numberFormat = NumberFormat("#,###", "ru_Ru");
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Общая стоимость",
              style: textStyle,
            ),
            Text("${numberFormat.format(discountPriceAmount)} ₽",
                style: textStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Скидка на товары",
              style: textStyle,
            ),
            Text(
                "${numberFormat.format(currentPriceAmount - discountPriceAmount)} ₽",
                style: textStyle)
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ItemsDivider(padding: 0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Итого",
              style: textTheme.headline2,
            ),
            Text("${numberFormat.format(currentPriceAmount)} ₽",
                style: textTheme.headline2)
          ],
        ),
      ],
    );
  }
}
