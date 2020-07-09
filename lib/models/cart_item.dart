import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';

class CartItem {
  final Seller seller;
  final List<Product> products;

  const CartItem({this.seller, this.products});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        seller: Seller.fromJson(json['seller']),
        products: [for (final product in json['products']) Product.fromJson(product)]);
  }
}
