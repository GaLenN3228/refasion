import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryLine extends StatelessWidget {
  final String label;
  final int value;

  final TextStyle textStyle;

  const SummaryLine({Key key, this.label, this.value, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,###", "ru_Ru");
    final valueText = value != 0 ? "${numberFormat.format(value)} ₽" : "Бесплатно";

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: textStyle ?? Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              valueText,
              style: textStyle ?? Theme.of(context).textTheme.bodyText2,
            )
          ],
        ),
      ],
    );
  }
}
