class ProductPrice {
  final int cash;

  ProductPrice({this.cash});

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(cash: json['cash']);
  }
}
