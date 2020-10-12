import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/utils/colors.dart';

final stateLabels = {
  ProductState.published: "Опубликован",
  ProductState.reserved: "В резерве",
  ProductState.onModeration: "На модерации",
};

final stateColors = {
  ProductState.published: primaryColor,
  ProductState.reserved: red,
  ProductState.onModeration: red,
};

class ProductStateTile extends StatelessWidget {
  final Product product;

  final bool showAllStates;

  final EdgeInsets padding;

  const ProductStateTile({this.product, this.showAllStates: false, this.padding});

  @override
  Widget build(BuildContext context) {
    final state = product?.state;

    if (state == null || (!showAllStates && product.available)) return SizedBox();

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        stateLabels[state],
        style: Theme.of(context).textTheme.subtitle2.copyWith(color: stateColors[state], height: 1.0),
      ),
    );
  }
}
