import 'package:refashioned_app/models/cart/cart_product.dart';
import 'package:refashioned_app/models/cart/delivery_data.dart';
import 'package:refashioned_app/models/cart/delivery_option.dart';
import 'package:refashioned_app/models/cart/item_summary.dart';
import 'package:refashioned_app/models/cart/shipping_cost.dart';

class CartItem {
  final DeliveryOption deliveryOption;
  final DeliveryData deliveryData;
  final List<CartProduct> cartProducts;
  final String id;

  const CartItem({this.id, this.cartProducts, this.deliveryOption, this.deliveryData});

  factory CartItem.fromJson(Map<String, dynamic> json) => json != null
      ? CartItem(
          id: json['id'],
          deliveryData: DeliveryData.fromJson(json['delivery_data']),
          deliveryOption: DeliveryOption.fromJson(json['delivery_object']),
          cartProducts: [
            for (final itemProduct in json['item_products']) CartProduct.fromJson(itemProduct)
          ],
        )
      : null;

  CartProduct findProduct(String productId) => cartProducts.firstWhere(
        (cartProduct) => cartProduct.product.id == productId || cartProduct.id == productId,
        orElse: () => null,
      );

  update(bool value) => cartProducts.forEach((cartProduct) => cartProduct.update(value: value));

  Map<String, dynamic> getOrderParameters() {
    final items = cartProducts
        .where((cartProduct) => cartProduct.selected.value)
        .map((cartProduct) => cartProduct.product.id)
        .toList();

    if (items.isNotEmpty)
      return {
        "delivery_company": deliveryOption.deliveryCompany.id,
        "delivery_object_id": deliveryOption.deliveryObject.id,
        "products": items,
      };
    else
      return null;
  }

  CartItemSummary getSummary() {
    int count = 0;
    int price = 0;
    int discout = 0;

    int selectedCount = 0;
    int selectedPrice = 0;
    int selectedDiscout = 0;

    cartProducts.forEach((cartProduct) {
      if (cartProduct.selected.value) {
        selectedCount++;
        selectedPrice += cartProduct.product.currentPrice;

        if (cartProduct.product.discountPrice != null)
          selectedDiscout += (cartProduct.product.currentPrice - cartProduct.product.discountPrice);
      }

      count++;
      price += cartProduct.product.currentPrice;

      if (cartProduct.product.discountPrice != null)
        discout += (cartProduct.product.currentPrice - cartProduct.product.discountPrice);
    });

    return CartItemSummary(
      count: count,
      price: price,
      discount: discout,
      selectedCount: selectedCount,
      selectedPrice: selectedPrice,
      selectedDiscount: selectedDiscout,
      shippingCost: deliveryOption?.deliveryCompany?.type != null && deliveryData?.cost != null
          ? ShippingCost(
              shipping: deliveryOption.deliveryCompany.type,
              cost: deliveryData.cost,
            )
          : null,
    );
  }

  @override
  String toString() => "cart item with id " + id.toString();
}
