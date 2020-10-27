import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/property.dart';
import 'package:refashioned_app/models/seller.dart';

import 'brand.dart';
import 'category.dart';

enum ProductState { published, reserved, onModeration }

enum ReserveState { FREE, RESERVED, RESERVED_BY_ME, PAYED }

final reserveStates = {
  "free": ReserveState.FREE,
  "reserved": ReserveState.RESERVED,
  "reserved_by_me": ReserveState.RESERVED_BY_ME,
  "payed": ReserveState.PAYED
};

final _stateLabels = {
  "Опубликован": ProductState.published,
  "В резерве": ProductState.reserved,
  "На модерации": ProductState.onModeration,
};

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
  final ProductState state;
  bool isFavourite = false;

  final PickPoint pickUpAddress;
  final List<DeliveryType> deliveryTypes;

  final ReserveState reserveState;
  final bool available;
  final List<ProductSize> sizes;

  Product({
    this.reserveState,
    this.sizes,
    this.available,
    this.pickUpAddress,
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
    this.images,
    this.state,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      print("Product.fromJson: no json");
      return null;
    }

    final stateObject = json['state'];
    final stateText = stateObject != null ? stateObject['text'] : null;
    final state = stateText != null ? _stateLabels[stateText] : null;

    final reserveText = json['reserve_state'];

    final reserveState = reserveText != null ? reserveStates[reserveText] : null;

    final available = reserveState == ReserveState.FREE || reserveState == ReserveState.RESERVED_BY_ME;

    final deliveryTypes = [
      if (json['takeaways'] != null)
        for (final deliveryType in json['takeaways']) DeliveryType.fromJson(deliveryType)
    ].where((element) => element != null).toList();

    final size = json['size'];
    final sizes = [
      if (size != null && size['international_values'] != null)
        for (final internationValue in size['international_values']) ProductSize.fromJson(internationValue)
    ].where((element) => element != null).toList();

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
      deliveryTypes: deliveryTypes,
      reserveState: reserveState,
      state: state,
      available: available,
      sizes: sizes,
    );
  }
}

class ProductSize {
  final String code;
  final String shortCode;
  final String value;
  final String secondaryValue;

  const ProductSize({this.shortCode, this.code, this.value, this.secondaryValue});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return ProductSize(
      code: json['code'],
      shortCode: json['short_code'],
      value: json['value'],
      secondaryValue: json['secondary_value'],
    );
  }
}
