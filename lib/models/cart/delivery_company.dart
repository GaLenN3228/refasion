import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

enum Delivery {
  PICKUP_ADDRESS,
  PICKUP_POINT,
  COURIER_DELIVERY,
  EXPRESS_DEVILERY
}

final deliveryTypes = {
  "pickup": Delivery.PICKUP_ADDRESS,
  "pickpoint": Delivery.PICKUP_POINT,
  "delivery": Delivery.COURIER_DELIVERY,
  "express": Delivery.EXPRESS_DEVILERY
};

final deliveryIcons = {
  Delivery.PICKUP_ADDRESS: IconAsset.personThin,
  Delivery.PICKUP_POINT: IconAsset.location,
  Delivery.COURIER_DELIVERY: IconAsset.courierDelivery,
  Delivery.EXPRESS_DEVILERY: IconAsset.expressDelivery
};

final deliveryLabels = {
  Delivery.PICKUP_ADDRESS: "Самовывоз",
  Delivery.PICKUP_POINT: "Пункт выдачи",
  Delivery.COURIER_DELIVERY: "Курьер",
  Delivery.EXPRESS_DEVILERY: "Экспресс"
};

class DeliveryCompany {
  final String name;
  final String id;
  final Delivery type;

  DeliveryCompany({this.type, this.id, this.name});

  factory DeliveryCompany.fromJson(Map<String, dynamic> json) {
    final type =
        json['delivery_type'] != null && json['delivery_type']['type'] != null
            ? deliveryTypes[json['delivery_type']['type']]
            : Delivery.PICKUP_POINT;

    return DeliveryCompany(
      id: json['id'],
      name: json['name'],
      type: type,
    );
  }
}
