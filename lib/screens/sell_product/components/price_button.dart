import 'package:flutter/material.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/utils/colors.dart';

enum PriceButtonType { tradeIn, diy }

class PriceButton extends StatelessWidget {
  final PriceButtonType type;
  final Brand brand;
  final Map<PriceButtonType, int> prices;
  final Function(int) onPush;

  PriceButton({Key key, this.type, this.brand, this.prices, this.onPush})
      : super(key: key);

  final bodyText = {
    PriceButtonType.tradeIn: "Максимальная скидка на новую вещь бренда",
    PriceButtonType.diy: "Сумма на руки в слкчае продажи"
  };

  final titleText = {
    PriceButtonType.tradeIn: "Сдать в Трейд-ин",
    PriceButtonType.diy: "Продать самому"
  };

  @override
  Widget build(BuildContext context) {
    final price = prices != null ? prices[type] ?? 0 : 0;
    final enabled = price != 0;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => enabled ? onPush(price) : () {},
      child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: ShapeDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    titleText[type],
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Container(
                    color: type == PriceButtonType.tradeIn && enabled
                        ? accentColor
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      price.toString() + " ₽",
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: 22,
                          color: enabled ? primaryColor : darkGrayColor),
                    ),
                  ),
                  Text(
                    bodyText[type],
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
