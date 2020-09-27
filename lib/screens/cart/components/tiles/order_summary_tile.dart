import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/order/order_summary.dart';
import 'package:refashioned_app/screens/cart/components/tiles/summary_line.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';

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
        if (orderSummary.discount != 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SummaryLine(label: "Скидка на вещи", value: -orderSummary.discount),
          ),
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
      ],
    );
  }
}
