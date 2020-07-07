
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/status.dart';

class ProductsResponse {
  final Status status;
  final ProductsContent productsContent;

  const ProductsResponse({this.status, this.productsContent});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
        status: Status.fromJson(json['status']),
        productsContent: ProductsContent.fromJson(json['content']));
  }
}

class ProductsContent {
  final int count;
  final List<Product> products;

  const ProductsContent({this.count, this.products});

  factory ProductsContent.fromJson(Map<String, dynamic> json) {
    return ProductsContent(
        count: json['count'],
        products: [for (final product in json['products']) Product.fromJson(product)]);
  }
}
