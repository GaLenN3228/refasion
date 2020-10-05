import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_option.dart';

class DeliveryType {
  final String name;
  final String title;
  final String id;
  final Delivery type;
  final List<DeliveryOption> deliveryOptions;

  const DeliveryType({this.id, this.deliveryOptions, this.type, this.name, this.title});

  factory DeliveryType.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final deliveryType = json['type'] != null ? deliveryTypes[json['type']] : null;

    final deliveryOptions = [
      if (json['items'] != null)
        for (final option in json['items']) DeliveryOption.fromJson(option)
    ].where((element) => element != null).toList();

    if (deliveryOptions.isEmpty || deliveryType == null) return null;

    return DeliveryType(
      id: json['id'],
      type: deliveryType,
      name: json['name'],
      title: json['title'],
      deliveryOptions: deliveryOptions,
    );
  }

  @override
  String toString() => type.toString() + ": " + name + ", " + title;
}
