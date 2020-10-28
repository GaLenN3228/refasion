import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/order/order_summary.dart';
import 'package:refashioned_app/screens/cart/components/tiles/summary_line.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/utils/colors.dart';

class OrderSummaryTile extends StatelessWidget {
  final OrderSummary orderSummary;

  const OrderSummaryTile({this.orderSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SummaryLine(label: "Общая стоимость", value: orderSummary.price),
        ),
        if (orderSummary?.discount != null && orderSummary.discount != 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SummaryLine(label: "Скидка на вещи", value: -orderSummary.discount),
          ),
        if (orderSummary.shippingCost != null)
          ...orderSummary.shippingCost
              .map(
                (shipping) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SummaryLine(label: shippingText[shipping.shipping], value: shipping.cost),
                ),
              )
              .toList(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ItemsDivider(padding: 0),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SummaryLine(
            label: "Итого",
            value: orderSummary.total,
            textStyle: Theme.of(context).textTheme.headline2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(style: Theme.of(context).textTheme.caption.copyWith(height: 1.4), children: [
              TextSpan(
                text: "Нажав «Оплатить», вы соглашаетесь с ",
              ),
              TextSpan(
                text: "условиями использования и оплаты",
                style: Theme.of(context).textTheme.caption.copyWith(
                      height: 1.4,
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
              ),
              TextSpan(
                text:
                    " маркетплейса REFASHIONED.\nС подробными условиями доставки можно ознакомиться на странице о доставке.",
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
