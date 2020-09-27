import 'package:refashioned_app/models/cart/shipping_cost.dart';

class OrderSummary {
  final int _totalCount;
  final int _totalPrice;
  final int _totalDiscount;

  final List<ShippingCost> _shippingCost;

  int get count => _totalCount;
  int get price => _totalPrice;
  int get discount => _totalDiscount;
  int get total => _totalPrice - _totalDiscount;

  List<ShippingCost> get shippingCost => _shippingCost;

  const OrderSummary(
    this._totalCount,
    this._totalPrice,
    this._totalDiscount,
    this._shippingCost,
  );

  @override
  String toString() =>
      "COUNT: " +
      count.toString() +
      ", PRICE: " +
      price.toString() +
      " ₽, DISCOUNT: " +
      discount.toString() +
      " ₽, TOTAL: " +
      total.toString() +
      " ₽";
}
