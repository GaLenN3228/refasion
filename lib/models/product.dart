import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/models/category.dart';

import 'package:refashioned_app/models/status.dart';

class ProductResponse {
  final Status status;
  final ProductContent productContent;

  const ProductResponse({this.status, this.productContent});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
        status: Status.fromJson(json['status']),
        productContent: ProductContent.fromJson(json['content']));
  }
}

class ProductContent {
  final int count;
  final List<Product> products;

  const ProductContent({this.count, this.products});

  factory ProductContent.fromJson(Map<String, dynamic> json) {
    return ProductContent(
        count: json['count'],
        products: [for (final product in json['products']) Product.fromJson(product)]);
  }
}

class Product {
  final String id;
  final String article;
  final String name;
  final int currentPrice;
  final int discountPrice;
  final String image;
  final Category category;
  final Brand brand;

  const Product(
      {this.id,
      this.article,
      this.name,
      this.currentPrice,
      this.discountPrice,
      this.image,
      this.category,
      this.brand});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        article: json['article'],
        name: json['name'],
        currentPrice: json['current_price'],
        discountPrice: json['discount_price'],
        image: json['image'],
        category: Category.fromJson(json['category']),
        brand: Brand.fromJson(json['brand']));
  }
}
