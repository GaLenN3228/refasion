import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/product/components/rating.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductSeller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: const Color.fromRGBO(0, 0, 0, 0.05)),
      ),
      child: ListTile(
        isThreeLine: false,
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: new AssetImage(
                'assets/seller.png',
              ),
            ),
          ),
        ),
        title: Text(
          "Продавец",
          style: textTheme.caption,
        ),
        subtitle: Text(
          "Камила",
          style: textTheme.subtitle1,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Rating(4.8),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "4.2",
                    style: textTheme.caption
                        .copyWith(fontWeight: FontWeight.w600, color: primaryColor),
                  ),
                )
              ],
            ),
            Text(
              "7 отзывов",
              style: textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
