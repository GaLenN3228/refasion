enum DeliveryType {
  PICKUP_ADDRESS,
  PICKUP_POINT,
  COURIER_DELIVERY,
  EXPRESS_DEVILERY
}

class DeliveryData {
  final String name;
  final String title;
  final String id;
  final DeliveryType deliveryType;
  final List<DeliveryOption> deliveryOptions;

  DeliveryData(
      {this.id,
      this.deliveryOptions,
      this.deliveryType,
      this.name,
      this.title});

  static DeliveryType _selectType(String code) {
    switch (code) {
      case "pickup":
        return DeliveryType.PICKUP_ADDRESS;
      case "courier":
        return DeliveryType.COURIER_DELIVERY;
      case "pickpoint":
        return DeliveryType.PICKUP_POINT;
      case "express":
        return DeliveryType.EXPRESS_DEVILERY;
      default:
        return DeliveryType.PICKUP_ADDRESS;
    }
  }

  factory DeliveryData.fromJson(Map<String, dynamic> json) => DeliveryData(
          id: json['id'],
          deliveryType: _selectType(json['type']),
          name: json['name'],
          title: json['title'],
          deliveryOptions: [
            for (final option in json['items']) DeliveryOption.fromJson(option)
          ]);

  @override
  String toString() => deliveryType.toString() + ": " + name + ", " + title;
}

class DeliveryOption {
  final String name;
  final String title;
  final String id;

  DeliveryOption({this.id, this.name, this.title});

  factory DeliveryOption.fromJson(Map<String, dynamic> json) => DeliveryOption(
        id: json['id'],
        name: json['name'],
        title: json['title'],
      );

  @override
  String toString() => name + ", " + title;
}
