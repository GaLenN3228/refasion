import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyText1;
    return Row(
      children: <Widget>[
        Text("1 000", style: textStyle.apply(decoration: TextDecoration.lineThrough)),
        Text("499 ₽", style: textStyle.apply(backgroundColor: const Color(0xFFFAD24E)))
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
