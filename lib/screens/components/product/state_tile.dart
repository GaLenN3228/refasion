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

  const ProductStateTile({this.product, this.showAllStates: false});

  @override
  Widget build(BuildContext context) {
    final state = product?.state;

    if (state == null || (!showAllStates && state == ProductState.published)) return SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        stateLabels[state],
        style: Theme.of(context).textTheme.subtitle2.copyWith(color: stateColors[state], height: 1.0),
      ),
    );
  }
}
