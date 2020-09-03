class Favourite {
  final String productId;

  const Favourite({this.productId});

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(productId: json['product']);
  }
}
