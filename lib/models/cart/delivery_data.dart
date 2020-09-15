class DeliveryData {
  final DateTime deliveryDay;
  final num cost;
  final String text;

  DeliveryData({this.deliveryDay, this.cost, this.text});

  factory DeliveryData.fromJson(Map<String, dynamic> json) => DeliveryData(
        cost: json['cost'],
        deliveryDay: DateTime.tryParse(json['delivery_day']),
        text: json['text'],
      );
}
