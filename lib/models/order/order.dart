class Order {
  final String id;

  const Order({this.id});

  factory Order.fromJson(Map<String, dynamic> json) => Order(id: json['id']);
}
