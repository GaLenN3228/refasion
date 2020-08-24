import 'package:refashioned_app/models/property.dart';
import 'package:refashioned_app/models/seller.dart';

import 'brand.dart';
import 'category.dart';

class Product {
  final String id;
  final String article;
  final String name;
  final int currentPrice;
  final int discountPrice;
  final String image;
  final Category category;
  final Brand brand;
  final Seller seller;
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
      this.seller,
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
        seller: json['seller'] != null ? Seller.fromJson(json['seller']) : null,
        description: json['description'],
        properties: [
          if (json['properties'] != null)
            for (final property in json['properties']) Property.fromJson(property)
        ],
        images: [
          if (json['images'] != null)
            for (final image in json['images']) image
        ]);
  }
}
