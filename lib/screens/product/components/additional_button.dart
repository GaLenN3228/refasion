import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class ProductAdditionalButton extends StatelessWidget {
  final String text;
  final Function() onSubCategoryClick;

  const ProductAdditionalButton({this.text, this.onSubCategoryClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onSubCategoryClick?.call,
      child: Column(
        children: [
          ItemsDivider(
            padding: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
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
          ),
        ],
      ),
    );
  }
}
