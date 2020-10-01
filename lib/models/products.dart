import 'package:refashioned_app/models/product.dart';

class ProductsContent {
  final int count;
  final String countText;
  final List<Product> products;

  const ProductsContent({this.countText, this.count, this.products});

  factory ProductsContent.fromJson(Map<String, dynamic> json) {
    return ProductsContent(count: json['count'], countText: json['count_text'], products: [
      if (json['products'] != null)
        for (final product in json['products']) Product.fromJson(product)
    ]);
  }
}
