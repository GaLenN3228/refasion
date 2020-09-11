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

  static DeliveryType _selectType(int code) {
    switch (code) {
      case 0:
        return DeliveryType.PICKUP_ADDRESS;
      case 1:
        return DeliveryType.COURIER_DELIVERY;
      case 2:
        return DeliveryType.PICKUP_POINT;
      case 3:
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
