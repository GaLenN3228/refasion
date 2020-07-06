import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CatalogBrands extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/catalog_brands_background.svg',
            height: 36,
            color: Color(0xFFFAD24E),
          ),
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/small_star.svg',
                  width: 14,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 8,
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
