import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_image.dart';
import 'package:refashioned_app/utils/colors.dart';

class CategoryBrands extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: [
          SVGImage(
            image: ImageAsset.catalogBrandsBackground,
            height: 36,
            color: accentColor,
          ),
          Positioned(
            left: 15,
            top: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SVGIcon(
                  icon: IconAsset.star,
                  size: 24,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "По брендам",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.w700),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
