import 'package:refashioned_app/models/cart/delivery_data.dart';
import 'package:refashioned_app/models/order/order_producr.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/seller.dart';

class OrderItem {
  final PickPoint deliveryObject;
  final DeliveryData deliveryData;
  final Seller seller;
  final int deliveryPrice;
  final List<OrderProduct> products;

  const OrderItem({this.deliveryData, this.seller, this.deliveryPrice, this.products, this.deliveryObject});

  factory OrderItem.fromJson(Map<String, dynamic> json) => json != null
      ? OrderItem(
          deliveryObject: PickPoint.fromJson(json['delivery_object']),
          deliveryData: DeliveryData.fromJson(json['delivery_data']),
          seller: Seller.fromJson(json['seller']),
          deliveryPrice: json['delivery_price'] != null ? (json['delivery_price'] as double)?.toInt() : null,
          products: json['products'] != null
              ? [
                  for (final product in json['products']) OrderProduct.fromJson(product),
                ]
              : null,
        )
      : null;

  @override
  String toString() => "seller: " + seller.name + ". products: " + products.join(",");
}
