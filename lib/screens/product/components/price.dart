import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductPrice extends StatelessWidget {
  final int currentPrice;
  final int discountPrice;

  const ProductPrice({Key key,@required this.currentPrice,@required this.discountPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle bodyText1 = textTheme.subtitle1;
    TextStyle bodyText2 = textTheme.bodyText2;
    return Row(
      children: <Widget>[
        this.discountPrice != null
            ? Text("$discountPrice",
                style: bodyText2.copyWith(decoration: TextDecoration.lineThrough))
            : Container(),
        this.discountPrice != null
            ? Container(
                width: 8,
              )
            : Container(),
        this.discountPrice == null
            ? Text("$currentPrice ₽", style: bodyText1)
            : Text("$currentPrice ₽", style: bodyText1.copyWith(backgroundColor: accentColor))
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
