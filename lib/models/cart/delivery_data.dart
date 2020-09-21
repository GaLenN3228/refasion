class DeliveryData {
  final DateTime deliveryDay;
  final num cost;
  final String text;

  const DeliveryData({this.deliveryDay, this.cost, this.text});

  factory DeliveryData.fromJson(Map<String, dynamic> json) => json != null
      ? DeliveryData(
          cost: json['cost'],
          deliveryDay: DateTime.tryParse(json['delivery_day']),
          text: json['text'],
        )
      : null;
}
