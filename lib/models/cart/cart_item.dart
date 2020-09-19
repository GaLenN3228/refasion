import 'package:refashioned_app/models/cart/cart_product.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_data.dart';

class CartItem {
  final DeliveryCompany deliveryCompany;
  final DeliveryData deliveryData;
  final List<CartProduct> cartProducts;
  final String id;

  CartItem(
      {this.id, this.cartProducts, this.deliveryCompany, this.deliveryData});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final deliveryData = json['delivery_data'] != null
        ? DeliveryData.fromJson(json['delivery_data'])
        : null;
    final deliveryCompany = json['delivery_object'] != null &&
            json['delivery_object']['delivery_company'] != null
        ? DeliveryCompany.fromJson(json['delivery_object']['delivery_company'])
        : null;

    return CartItem(
      id: json['id'],
      deliveryData: deliveryData,
      deliveryCompany: deliveryCompany,
      cartProducts: [
        for (final itemProduct in json['item_products'])
          CartProduct.fromJson(itemProduct)
      ],
    );
  }

  CartProduct findProduct(String productId) => cartProducts.firstWhere(
        (cartProduct) =>
            cartProduct.product.id == productId || cartProduct.id == productId,
        orElse: () => null,
      );

  update(bool value) =>
      cartProducts.forEach((cartProduct) => cartProduct.update(value: value));

  @override
  String toString() => "cart item with id " + id.toString();
}
