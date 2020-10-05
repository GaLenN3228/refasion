import 'package:refashioned_app/models/cart/cart_item.dart';
import 'package:refashioned_app/models/cart/cart_product.dart';

class Cart {
  final String text;
  final num productsCount;
  final List<CartItem> groups;

  Cart({this.text, this.productsCount, this.groups});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      text: json['text'],
      productsCount: json['products_count'],
      groups: [
        if (json['items'] != null)
          for (final cartItem in json['items']) CartItem.fromJson(cartItem)
      ],
    );
  }

  CartItem findGroupOfProduct(String productId) =>
      groups.firstWhere((group) => group.findProduct(productId) != null, orElse: () => null);

  CartItem getGroup(String cartItemId) => groups.firstWhere((group) => group.id == cartItemId, orElse: () => null);

  CartProduct getProduct(String productId) => findGroupOfProduct(productId)?.findProduct(productId);

  bool checkPresence(String productId) => getProduct(productId) != null;

  String getProductItemId(String productId) => getProduct(productId)?.id;
}
