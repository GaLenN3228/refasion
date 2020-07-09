import 'package:refashioned_app/models/property.dart';
import 'package:refashioned_app/models/status.dart';

import 'brand.dart';
import 'category.dart';

class ProductResponse {
  final Status status;
  final Product product;

  const ProductResponse({this.status, this.product});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
        status: Status.fromJson(json['status']), product: Product.fromJson(json['content']));
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
  final String description;
  final List<Property> properties;
  final List<String> images;

  const Product(
      {this.id,
      this.article,
      this.name,
      this.currentPrice,
      this.discountPrice,
      this.image,
      this.category,
      this.brand,
      this.description,
      this.properties,
      this.images});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        article: json['article'],
        name: json['name'],
        currentPrice: json['current_price'],
        discountPrice: json['discount_price'],
        image: json['image'],
        category: Category.fromJson(json['category']),
        brand: Brand.fromJson(json['brand']),
        description: json['description'],
        properties: [if (json['properties'] != null) for (final property in json['properties']) Property.fromJson(property)],
        images: [if (json['images'] != null) for (final image in json['images']) image]
    );
  }
}
