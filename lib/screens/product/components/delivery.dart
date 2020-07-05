import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductDelivery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Доставка"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[Text("Ваш город: "), Text("Москва")],
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(3.0),
              ),
              onPressed: () {},
              child: Text("ИЗМЕНИТЬ"),
            )
          ],
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: SvgPicture.asset(
            'assets/shipping.svg',
            height: 16,
            color: Colors.black,
          ),
          title: Text("Курьером, завтра, 23 июня"),
          subtitle: Text("Бесплатно"),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: SvgPicture.asset(
            'assets/position.svg',
            height: 16,
            color: Colors.black,
          ),
          title: Text("В пункт выдачи, завтра, 23 июня"),
          subtitle: Text("Бесплатно"),
        ),
        Container(
          color: const Color(0xFFE6E6E6),
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 1,
        ),
      ],
    );
  }
}
