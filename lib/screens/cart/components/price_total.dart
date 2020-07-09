import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/utils/colors.dart';

class CartPriceTotal extends StatelessWidget {
  final int discountPriceAmount;
  final int currentPriceAmount;

  const CartPriceTotal({@required this.discountPriceAmount, @required this.currentPriceAmount});

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
            Text("${numberFormat.format(discountPriceAmount)} ₽", style: textStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Скидка на товары",
              style: textStyle,
            ),
            Text("${numberFormat.format(currentPriceAmount - discountPriceAmount)} ₽", style:
            textStyle)
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
              color: lightGrayColor,
            )),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Итого",
                style: textTheme.headline2,
              ),
              Text("${numberFormat.format(currentPriceAmount)} ₽", style: textTheme.headline2)
            ],
          ),
        )
      ],
    );
  }
}
