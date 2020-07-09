import 'package:refashioned_app/models/cart_item.dart';
import 'package:refashioned_app/models/status.dart';

class CartResponse {
  final Status status;
  final Cart cart;

  const CartResponse({this.status, this.cart});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
        status: Status.fromJson(json['status']), cart: Cart.fromJson(json['content']));
  }
}

class Cart {
  final int productsCounts;
  final String promoCode;
  final int currentPriceAmount;
  final int discountPriceAmount;
  final List<CartItem> cartItems;

  Cart(
      {this.productsCounts,
      this.promoCode,
      this.currentPriceAmount,
      this.discountPriceAmount,
      this.cartItems});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productsCounts: json['products_counts'],
      promoCode: json['promocode'],
      currentPriceAmount: json['current_price_amount'],
      discountPriceAmount: json['discount_price_amount'],
      cartItems: [for (final cartItem in json['cart_items']) CartItem.fromJson(cartItem)],
    );
  }
}
