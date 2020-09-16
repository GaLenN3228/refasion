import 'package:refashioned_app/models/cart/cart_item.dart';
import 'package:refashioned_app/models/cart/cart_product.dart';

class Cart {
  final String text;
  final num productsCount;
  final num totalCurrentPrice;
  final num totalDiscountPrice;
  final num totalDiscount;
  final List<CartItem> groups;

  Cart(
      {this.text,
      this.productsCount,
      this.totalCurrentPrice,
      this.totalDiscountPrice,
      this.totalDiscount,
      this.groups});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      text: json['text'],
      productsCount: json['products_count'],
      totalCurrentPrice: json['total_current_price'],
      totalDiscountPrice: json['total_discount_price'],
      totalDiscount: json['total_discount'],
      groups: [
        if (json['items'] != null)
          for (final cartItem in json['items']) CartItem.fromJson(cartItem)
      ],
    );
  }

  CartItem getGroup(String productId) =>
      groups.firstWhere((group) => group.getProduct(productId) != null,
          orElse: () => null);

  CartProduct getProduct(String productId) =>
      getGroup(productId)?.getProduct(productId);

  bool checkPresence(String productId) => getProduct(productId) != null;

  String getProductItemId(String productId) => getProduct(productId)?.id;
}