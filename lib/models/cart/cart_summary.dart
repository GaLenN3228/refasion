import 'package:intl/intl.dart';
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
          _shippingCost.fold(0, (previousValue, shipping) => previousValue + shipping.cost) -
          _selectedDiscount
      : _totalPrice - _totalDiscount;

  String get buttonCaption => countText(count) + ", ${NumberFormat("#,###", "ru_Ru").format(total)} ₽";

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

  String countText(int count) {
    final tens = count % 100;

    if (tens >= 11 && tens <= 19) return "$count вещей";

    switch (count % 10) {
      case 1:
        return "$count вещь";
      case 2:
      case 3:
      case 4:
        return "$count вещи";
      default:
        return "$count вещей";
    }
  }

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
