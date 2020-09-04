enum DeliveryType {
  PICKUP_ADDRESS,
  PICKUP_POINT,
  COURIER_DELIVERY,
  EXPRESS_DEVILERY
}

class DeliveryOptionData {
  final DeliveryType deliveryType;
  final String title;
  final String subtitle;

  DeliveryOptionData({this.deliveryType, this.title, this.subtitle});

  factory DeliveryOptionData.fromJson(Map<String, dynamic> json) =>
      DeliveryOptionData(
        deliveryType: DeliveryType.PICKUP_ADDRESS,
        title: "Самовывоз от продавца",
        subtitle: "Бесплатно. По адресу продавца",
      );
}
