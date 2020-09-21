import 'package:refashioned_app/models/cart/cart_product.dart';
import 'package:refashioned_app/models/cart/delivery_data.dart';
import 'package:refashioned_app/models/cart/delivery_option.dart';

class CartItem {
  final DeliveryOption deliveryOption;
  final DeliveryData deliveryData;
  final List<CartProduct> cartProducts;
  final String id;

  const CartItem({this.id, this.cartProducts, this.deliveryOption, this.deliveryData});

  factory CartItem.fromJson(Map<String, dynamic> json) => json != null
      ? CartItem(
          id: json['id'],
          deliveryData: DeliveryData.fromJson(json['delivery_data']),
          deliveryOption: DeliveryOption.fromJson(json['delivery_object']),
          cartProducts: [
            for (final itemProduct in json['item_products']) CartProduct.fromJson(itemProduct)
          ],
        )
      : null;

  CartProduct findProduct(String productId) => cartProducts.firstWhere(
        (cartProduct) => cartProduct.product.id == productId || cartProduct.id == productId,
        orElse: () => null,
      );

  update(bool value) => cartProducts.forEach((cartProduct) => cartProduct.update(value: value));

  @override
  String toString() => "cart item with id " + id.toString();
}
