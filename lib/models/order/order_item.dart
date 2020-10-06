import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_data.dart';
import 'package:refashioned_app/models/cart/shipping_cost.dart';
import 'package:refashioned_app/models/order/order_producr.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/models/user_address.dart';

class OrderItem {
  final UserAddress deliveryObject;
  final String deliveryText;
  final Seller seller;
  final List<OrderProduct> products;
  final ShippingCost shippingCost;

  const OrderItem({
    this.shippingCost,
    this.deliveryText,
    this.seller,
    this.products,
    this.deliveryObject,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final deliveryObject = json['delivery_object'] != null ? UserAddress.fromJson(json['delivery_object']) : null;
    final deliveryData = json['delivery_data'] != null ? DeliveryData.fromJson(json['delivery_data']) : null;
    final seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;

    final deliveryPrice = json['delivery_price'] != null ? json['delivery_price'] : null;
    final deliveryType = json['delivery_type'] != null ? deliveryTypes[json['delivery_type']] : null;

    final shippingCost = deliveryPrice != null && deliveryType != null
        ? ShippingCost(cost: deliveryPrice, shipping: deliveryType)
        : null;

    final products = json['products'] != null
        ? [
            for (final product in json['products']) OrderProduct.fromJson(product),
          ]
        : null;

    return OrderItem(
      deliveryObject: deliveryObject,
      deliveryText: deliveryData.text,
      seller: seller,
      products: products,
      shippingCost: shippingCost,
    );
  }

  @override
  String toString() => "seller: " + seller.name + ". products: " + products.join(",");
}
