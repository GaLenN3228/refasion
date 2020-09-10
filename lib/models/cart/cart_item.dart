import 'package:refashioned_app/models/cart/cart_product.dart';

class CartItem {
  final String deliveryObject;
  final String deliveryData;
  final List<CartProduct> products;
  final String id;

  CartItem({this.id, this.products, this.deliveryObject, this.deliveryData});

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        deliveryData: json['delivaery_data'],
        deliveryObject: json['delivery_object'],
        products: [
          for (final itemProduct in json['item_products'])
            CartProduct.fromJson(itemProduct)
        ],
      );

  CartProduct getProduct(String productId) => products.firstWhere(
        (cartProduct) => cartProduct.product.id == productId,
        orElse: () => null,
      );
}
