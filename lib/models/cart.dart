import 'package:refashioned_app/models/cart_item.dart';

class Cart {
  final int productsCount;
  final String promoCode;
  final int currentPriceAmount;
  final int discountPriceAmount;
  final int totalDiscount;
  final List<CartItem> cartItems;

  Cart(
      {this.productsCount,
      this.promoCode,
      this.currentPriceAmount,
      this.discountPriceAmount,
      this.totalDiscount,
      this.cartItems});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productsCount: json['products_count'],
      promoCode: json['promocode'],
      currentPriceAmount: json['total_current_price'],
      discountPriceAmount: json['total_discount_price'],
      totalDiscount: json['total_discount'],
      cartItems: [if (json['items'] != null) for (final cartItem in json['items']) CartItem.fromJson(cartItem)],
    );
  }
}
