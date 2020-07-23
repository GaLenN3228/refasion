import 'package:refashioned_app/models/status.dart';

class ProductsCountResponse {
  final Status status;
  final ProductsCount productsCount;

  const ProductsCountResponse({this.status, this.productsCount});

  factory ProductsCountResponse.fromJson(Map<String, dynamic> json) {
    return ProductsCountResponse(
        status: Status.fromJson(json['status']),
        productsCount: ProductsCount.fromJson(json['content']));
  }
}

class ProductsCount {
  final String text;

  const ProductsCount({this.text});

  factory ProductsCount.fromJson(Map<String, dynamic> json) {
    return ProductsCount(text: json['text']);
  }

  String get getDetail => text;
}
