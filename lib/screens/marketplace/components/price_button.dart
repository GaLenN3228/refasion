import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/utils/colors.dart';

enum PriceButtonType { tradeIn, diy }

class PriceButton extends StatelessWidget {
  final PriceButtonType type;
  final Brand brand;
  final Map<PriceButtonType, int> prices;
  final Function() onPush;

  PriceButton({Key key, this.type, this.brand, this.prices, this.onPush}) : super(key: key);

  final bodyText = {
    PriceButtonType.tradeIn: "Максимальная скидка на новую вещь бренда",
    PriceButtonType.diy: "Сумма на руки в случае продажи"
  };

  final titleText = {
    PriceButtonType.tradeIn: "Сдать в Трейд-ин",
    PriceButtonType.diy: "Вы получите"
  };

  final numberFormat = NumberFormat("#,###", "ru_Ru");

  @override
  Widget build(BuildContext context) {
    final price = prices != null && prices[type] != null ? prices[type] : 0;
    final enabled = price != 0;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => enabled ? onPush() : () {},
      child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: ShapeDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    titleText[type],
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Container(
                    color: enabled ? accentColor : Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      "${numberFormat.format(price)}" + " ₽",
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontSize: 22, color: enabled ? primaryColor : darkGrayColor),
                    ),
                  ),
                  Text(
                    bodyText[type],
                    style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
