import 'package:refashioned_app/models/cart_item.dart';
import 'package:refashioned_app/models/status.dart';

class CartResponse {
  final Status status;
  final Cart cart;

  const CartResponse({this.status, this.cart});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(status: Status.fromJson(json['status']), cart: Cart.fromJson(json['content']));
  }
}

class Cart {
  final int productsCounts;
  final String promoCode;
  final int currentPriceAmount;
  final int discountPriceAmount;
  final int totalDiscount;
  final List<CartItem> cartItems;

  Cart(
      {this.productsCounts,
      this.promoCode,
      this.currentPriceAmount,
      this.discountPriceAmount,
      this.totalDiscount,
      this.cartItems});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productsCounts: json['products_counts'],
      promoCode: json['promocode'],
      currentPriceAmount: json['total_current_price'],
      discountPriceAmount: json['total_discount_price'],
      totalDiscount: json['total_discount'],
      cartItems: [if (json['items'] != null) for (final cartItem in json['items']) CartItem.fromJson(cartItem)],
    );
  }
}
