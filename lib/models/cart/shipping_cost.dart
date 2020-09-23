import 'package:refashioned_app/models/cart/delivery_company.dart';

class ShippingCost {
  final Delivery shipping;
  final int cost;

  const ShippingCost({
    this.cost,
    this.shipping,
  });

  @override
  String toString() => deliveryLabels[shipping] + ": " + cost.toString() + " ₽";
}
