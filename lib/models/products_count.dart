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
  final String detail;

  const ProductsCount({this.detail});

  factory ProductsCount.fromJson(Map<String, dynamic> json) {
    return ProductsCount(detail: json['detail']);
  }

  String get getDetail => detail;
}
