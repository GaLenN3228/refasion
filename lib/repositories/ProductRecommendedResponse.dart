import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/status.dart';

class ProductsRecommendedResponse {
  final Status status;
  final List<Product> products;

  const ProductsRecommendedResponse({this.status, this.products});

  factory ProductsRecommendedResponse.fromJson(Map<String, dynamic> json) {
    return ProductsRecommendedResponse(status: Status.fromJson(json['status']), products: [
      if (json['content'] != null)
        for (final product in json['content']) Product.fromJson(product)
    ]);
  }
}
