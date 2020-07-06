import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductAdditionalButton extends StatelessWidget {
  final String text;

  const ProductAdditionalButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(text, style:Theme.of(context).textTheme.subtitle1),
            SvgPicture.asset(
              'assets/arrow_right.svg',
              height: 12,
              color: primaryColor,
            )
          ],
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
