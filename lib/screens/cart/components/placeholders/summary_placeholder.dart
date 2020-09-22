import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';

class SummaryPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle textStyle = textTheme.bodyText2.copyWith(height: 2);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Общая стоимость",
              style: textStyle,
            ),
            Text("999 ₽", style: textStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Скидка на товары",
              style: textStyle,
            ),
            Text("99 ₽", style: textStyle)
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
            Text("900 ₽", style: textTheme.headline2)
          ],
        ),
      ],
    );
  }
}
