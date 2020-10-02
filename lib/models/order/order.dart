import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/shipping_cost.dart';
import 'package:refashioned_app/models/order/order_item.dart';
import 'package:refashioned_app/models/order/order_summary.dart';

class Order {
  final String id;
  final String number;
  final String state;

  final String paymentType;

  final List<OrderItem> items;

  final OrderSummary orderSummary;

  const Order({
    this.items,
    this.state,
    this.paymentType,
    this.number,
    this.id,
    this.orderSummary,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final totalPrice = json['products_price'];
    final fullPrice = json['full_price'];
    final discount = json['discount'];

    final items = json['items'] != null
        ? [
            for (final item in json['items']) OrderItem.fromJson(item),
          ]
        : null;

    List<ShippingCost> shippingCost = [];
    if (items != null) {
      bool hasPickUpAddress = false;
      items.forEach((cartItem) {
        final itemShippingCost = cartItem.shippingCost;
        if (itemShippingCost != null && (!hasPickUpAddress || itemShippingCost.shipping != Delivery.PICKUP_ADDRESS)) {
          shippingCost.add(itemShippingCost);
          hasPickUpAddress = itemShippingCost.shipping == Delivery.PICKUP_ADDRESS;
        }
      });
    }

    final orderSummary = OrderSummary(totalPrice, discount, shippingCost, fullPrice);

    return Order(
      id: json['id'],
      number: json['number'],
      state: json['state'],
      paymentType: json['payment_type'],
      items: items,
      orderSummary: orderSummary,
    );
  }

  @override
  String toString() =>
      "\nORDER " +
      number +
      "\nTOTAL " +
      orderSummary?.total.toString() +
      " ₽\nTYPE " +
      paymentType.toString() +
      "\nITEMS\n" +
      items?.join("\n").toString();
}
