import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
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
  List<Property> properties;
  final List<String> images;
  bool isFavourite = false;

  final PickPoint pickUpAddress;
  final List<DeliveryType> deliveryTypes;

  Product(
      {this.pickUpAddress,
      this.deliveryTypes,
      this.id,
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
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      seller: json['seller'] != null ? Seller.fromJson(json['seller']) : null,
      description: json['description'],
      properties: [
        if (json['properties'] != null)
          for (final property in json['properties']) Property.fromJson(property)
      ],
      images: [
        if (json['images'] != null)
          for (final image in json['images']) image
      ],
      pickUpAddress: json['pickup'] != null ? PickPoint.fromJson(json['pickup']) : null,
      deliveryTypes: [
        if (json['takeaways'] != null)
          for (final deliveryType in json['takeaways']) DeliveryType.fromJson(deliveryType)
      ],
    );
  }
}
