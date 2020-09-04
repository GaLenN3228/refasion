import 'package:refashioned_app/screens/cart/cart/data/cart_data.dart';

class Cart {
  final String text;
  final int productsCount;
  final int totalCurrentPrice;
  final int totalDiscountPrice;
  final int totalDiscount;
  final List<CartGroupData> groups;

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
          for (final cartItem in json['items']) CartGroupData.fromJson(cartItem)
      ],
    );
  }
}
