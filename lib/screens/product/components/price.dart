import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductPrice extends StatelessWidget {
  final int currentPrice;
  final int discountPrice;

  const ProductPrice({Key key, @required this.currentPrice, @required this.discountPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle subtitle = textTheme.subtitle1;
    TextStyle bodyText2 = textTheme.bodyText2;
    final numberFormat = NumberFormat("#,###", "ru_Ru");
    return Row(
      children: <Widget>[
        discountPrice > 0
            ? Text("${numberFormat.format(discountPrice)}",
                style: bodyText2.copyWith(decoration: TextDecoration.lineThrough))
            : Container(),
        discountPrice > 0
            ? Container(
                width: 8,
              )
            : Container(),
        Container(
          color: discountPrice > 0 ? accentColor : Color(0),
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: Text("${numberFormat.format(currentPrice)} ₽", style: subtitle),
        )
      ],
    );
  }
}
/*
osition: absolute;
left: 0.3%;
right: 89.85%;
top: 18.05%;
bottom: 80.9%;

font-family: SF UI Text;
font-style: normal;
font-weight: 500;
font-size: 12px;
line-height: 20px;
/* identical to box height, or 167% */


color: #959595;



 */
