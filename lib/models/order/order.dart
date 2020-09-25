import 'package:refashioned_app/models/order/order_item.dart';

class Order {
  final String id;
  final String number;
  final String state;

  final String paymentType;

  final int productsPrice;
  final int totalPrice;
  final int discount;

  final List<OrderItem> items;

  const Order({
    this.items,
    this.state,
    this.paymentType,
    this.productsPrice,
    this.totalPrice,
    this.discount,
    this.number,
    this.id,
  });

  factory Order.fromJson(Map<String, dynamic> json) => json != null
      ? Order(
          id: json['id'],
          number: json['number'],
          totalPrice: json['full_price'],
          productsPrice: json['products_price'],
          state: json['state'],
          paymentType: json['payment_type'],
          discount: json['discount'],
          items: json['items'] != null
              ? [
                  for (final item in json['items']) OrderItem.fromJson(item),
                ]
              : null,
        )
      : null;

  @override
  String toString() =>
      "\nORDER " +
      number +
      "\nTOTAL " +
      totalPrice.toString() +
      " ₽\nTYPE " +
      paymentType.toString() +
      "\nITEMS\n" +
      items?.join("\n").toString();
}
