import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/cart_summary.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/screens/cart/components/tiles/summary_line.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';

class CartSummaryTile extends StatelessWidget {
  final CartSummary cartSummary;

  const CartSummaryTile({this.cartSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SummaryLine(label: "Общая стоимость", value: cartSummary.price),
        ),
        if (cartSummary.discount != 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SummaryLine(label: "Скидка на вещи", value: -cartSummary.discount),
          ),
        ...cartSummary.shippingCost
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
            value: cartSummary.total,
            textStyle: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    );
  }
}
