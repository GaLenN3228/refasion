import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_option.dart';

class DeliveryType {
  final String name;
  final String title;
  final String id;
  final Delivery type;
  final List<DeliveryOption> deliveryOptions;

  const DeliveryType({this.id, this.deliveryOptions, this.type, this.name, this.title});

  factory DeliveryType.fromJson(Map<String, dynamic> json) => json != null
      ? DeliveryType(
          id: json['id'],
          type: deliveryTypes[json['type']] ?? Delivery.PICKUP_POINT,
          name: json['name'],
          title: json['title'],
          deliveryOptions: [for (final option in json['items']) DeliveryOption.fromJson(option)],
        )
      : null;

  @override
  String toString() => type.toString() + ": " + name + ", " + title;
}
