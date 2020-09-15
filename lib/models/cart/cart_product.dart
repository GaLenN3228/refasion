import 'package:flutter/widgets.dart';
import 'package:refashioned_app/models/product.dart';

class CartProduct {
  final String id;
  final Product product;
  final ValueNotifier<bool> selected;

  const CartProduct({this.selected, this.id, this.product});

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        id: json['id'],
        product: Product.fromJson(json['product']),
        selected: ValueNotifier(false),
      );

  update({bool value}) => selected.value = value ?? !selected.value;
}
