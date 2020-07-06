import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/components/button.dart';

class ProductDelivery extends StatelessWidget {
  @override
  Widget _deliveryItem(TextTheme textTheme, String assetName, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 26,
            alignment: Alignment.topLeft,
            child: SvgPicture.asset(
              assetName,
              height: 16,
              color: Colors.black,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: textTheme.subtitle1),
              Text(subtitle, style: textTheme.bodyText2.copyWith(height: 1.7))
            ],
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Доставка", style: textTheme.headline2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Ваш город: ", style: textTheme.bodyText2),
                Text("Москва", style: textTheme.bodyText1)
              ],
            ),
            Button(
              "Изменить",
              buttonStyle: ButtonStyle.outline,
            )
          ],
        ),
        _deliveryItem(textTheme, 'assets/shipping.svg', "Курьером, завтра, 23 июня", "Бесплатно"),
        _deliveryItem(
            textTheme,
            'assets/position.svg',
            "В пункт выдачи, завтра, 23 июня",
            "Бесплатн"
                "о"),
        Container(
          color: const Color(0xFFE6E6E6),
          margin: EdgeInsets.symmetric(vertical: 16),
          height: 1,
        ),
      ],
    );
  }
}
