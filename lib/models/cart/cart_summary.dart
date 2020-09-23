import 'package:refashioned_app/models/cart/shipping_cost.dart';

class CartSummary {
  final int _totalCount;
  final int _totalPrice;
  final int _totalDiscount;

  final int _selectedCount;
  final int _selectedPrice;
  final int _selectedDiscount;

  final List<ShippingCost> _shippingCost;

  bool get canOrder => _selectedCount != null && _selectedCount > 0;

  int get count => canOrder ? _selectedCount : _totalCount;
  int get price => canOrder ? _selectedPrice : _totalPrice;
  int get discount => canOrder ? _selectedDiscount : _totalDiscount;
  int get total => canOrder
      ? _selectedPrice +
          _shippingCost.fold(0, (previousValue, shipping) => previousValue + shipping.cost)
      : _totalPrice;

  List<ShippingCost> get shippingCost => _shippingCost;

  const CartSummary(
    this._totalCount,
    this._totalPrice,
    this._totalDiscount,
    this._selectedCount,
    this._selectedPrice,
    this._selectedDiscount,
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
