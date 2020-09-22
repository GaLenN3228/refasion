import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/checkbox/stateless.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class CartProductPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: RefashionedCheckboxStateless(
              value: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: Container(
              width: 80,
              height: 80,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: darkGrayColor,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // ProductPrice(
                  //   product: product,
                  // ),
                  // ProductBrand(product),
                  // ProductSize(product),
                ],
              ),
            ),
          ),
          SVGIcon(
            icon: IconAsset.more,
            size: 24,
          )
        ],
      ),
    );
  }
}
