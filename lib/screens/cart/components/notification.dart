import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CartNotification extends StatelessWidget {
  final int sellerCounts;

  const CartNotification(this.sellerCounts);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return sellerCounts > 1 ? Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 16),
      color: Color.fromRGBO(250, 210, 78, 0.3),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                'assets/box.png',
                height: 32,
              ),
              SizedBox(
                width: 5,
              ),
              Text("x $sellerCounts", style: textTheme.headline2)
            ],
          ),
          Text("Заказ приедет в нескольких посылках, "
              "потому что товары находятся у разных продавцов.",
          style: textTheme.bodyText1)
        ],
      ),
    ) : Container();
  }
}
