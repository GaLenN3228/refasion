import 'package:refashioned_app/models/cart/delivery_company.dart';

class DeliveryType {
  final String name;
  final String title;
  final String id;
  final Delivery type;
  final List<DeliveryCompany> items;

  DeliveryType({this.id, this.items, this.type, this.name, this.title});

  factory DeliveryType.fromJson(Map<String, dynamic> json) => DeliveryType(
          id: json['id'],
          type: deliveryTypes[json['type']] ?? Delivery.PICKUP_POINT,
          name: json['name'],
          title: json['title'],
          items: [
            for (final option in json['items']) DeliveryCompany.fromJson(option)
          ]);

  @override
  String toString() => type.toString() + ": " + name + ", " + title;
}
