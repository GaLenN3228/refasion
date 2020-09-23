import 'package:refashioned_app/models/cart/shipping_cost.dart';

class CartItemSummary {
  final int count;
  final int price;
  final int discount;

  final int selectedCount;
  final int selectedPrice;
  final int selectedDiscount;

  final ShippingCost shippingCost;

  const CartItemSummary({
    this.count,
    this.selectedCount,
    this.selectedPrice,
    this.selectedDiscount,
    this.price,
    this.discount,
    this.shippingCost,
  });
}
