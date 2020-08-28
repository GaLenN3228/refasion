import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class ProductDelivery extends StatelessWidget {
  Widget _deliveryItem(
      TextTheme textTheme, IconAsset icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SVGIcon(
            icon: icon,
            size: 24,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: textTheme.subtitle1),
                  Text(subtitle,
                      style: textTheme.bodyText2.copyWith(height: 1.7))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
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
        _deliveryItem(
          textTheme,
          IconAsset.courierDelivery,
          "Курьером, завтра, 23 июня",
          "Бесплатно",
        ),
        _deliveryItem(
          textTheme,
          IconAsset.location,
          "В пункт выдачи, завтра, 23 июня",
          "Бесплатно",
        ),
        Container(
          color: const Color(0xFFE6E6E6),
          margin: EdgeInsets.symmetric(vertical: 16),
          height: 1,
        ),
      ],
    );
  }
}
