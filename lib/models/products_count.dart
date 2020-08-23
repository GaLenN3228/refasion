class ProductsCount {
  final String text;

  const ProductsCount({this.text});

  factory ProductsCount.fromJson(Map<String, dynamic> json) {
    return ProductsCount(text: json['text']);
  }

  String get getCountText => text;
}
