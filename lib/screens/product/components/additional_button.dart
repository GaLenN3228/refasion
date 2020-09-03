import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class ProductAdditionalButton extends StatelessWidget {
  final String text;
  final Function() onSubCategoryClick;

  const ProductAdditionalButton({this.text, this.onSubCategoryClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onSubCategoryClick();
      },
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(text, style: Theme.of(context).textTheme.subtitle1),
              RotatedBox(
                quarterTurns: 2,
                child: SVGIcon(
                  icon: IconAsset.back,
                  size: 14,
                ),
              ),
            ],
          ),
          Container(
            color: const Color(0xFFE6E6E6),
            margin: EdgeInsets.symmetric(vertical: 16),
            height: 1,
          ),
        ],
      ),
    );
  }
}
