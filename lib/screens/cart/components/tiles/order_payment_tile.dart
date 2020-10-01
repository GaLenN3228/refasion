import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class OrderPaymentTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Text(
            "Способ оплаты",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 5),
              child: SVGIcon(
                icon: IconAsset.bank_card,
                size: 24,
              ),
            ),
            Text(
              "Картой онлайн",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Image.asset(
            "assets/images/png/payments.png",
            height: 18,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          child: Container(
            decoration: ShapeDecoration(
              color: accentColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: accentColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Деньги можно вернуть",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Если передумаете покупать или не получите заказ, вернём всю сумму.",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
