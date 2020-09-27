import 'package:refashioned_app/models/cart/shipping_cost.dart';

class OrderSummary {
  final int _totalPrice;
  final int _totalDiscount;

  final List<ShippingCost> _shippingCost;

  int get price => _totalPrice;
  int get discount => _totalDiscount ?? 0;
  int get total => _totalPrice - discount;

  List<ShippingCost> get shippingCost => _shippingCost;

  const OrderSummary(
    this._totalPrice,
    this._totalDiscount,
    this._shippingCost,
  );

  @override
  String toString() =>
      ", PRICE: " + price.toString() + " ₽, DISCOUNT: " + discount.toString() + " ₽, TOTAL: " + total.toString() + " ₽";
}
