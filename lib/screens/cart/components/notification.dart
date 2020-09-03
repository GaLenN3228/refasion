import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class CartNotification extends StatelessWidget {
  final int sellerCounts;

  const CartNotification(this.sellerCounts);
  @override
  Widget build(BuildContext context) {
    if (sellerCounts == 0) return SizedBox();

    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 20, 20),
      decoration: ShapeDecoration(
        color: accentColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: accentColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SVGIcon(
                icon: IconAsset.box,
                size: 40,
              ),
              Text("x $sellerCounts",
                  style: Theme.of(context).textTheme.headline2)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              "Заказ приедет в нескольких посылках. У каждой посылки свои сроки и стоимость доставки",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )
        ],
      ),
    );
  }
}
