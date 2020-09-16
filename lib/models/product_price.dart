class ProductPrice {
  final double cash;

  ProductPrice({this.cash});

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(cash: json['cash']);
  }
}
