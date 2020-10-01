class OrderProduct {
  final String id;
  final String image;

  const OrderProduct({this.id, this.image});

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
        id: json['id'],
        image: json['image'],
      );

  @override
  String toString() => "id " + id;
}
