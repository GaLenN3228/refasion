import 'package:refashioned_app/models/product.dart';

class ProductsContent {
  final int count;
  final List<Product> products;

  const ProductsContent({this.count, this.products});

  factory ProductsContent.fromJson(Map<String, dynamic> json) {
    return ProductsContent(count: json['count'], products: [
      if (json['products'] != null) for (final product in json['products']) Product.fromJson(product)
    ]);
  }
}
