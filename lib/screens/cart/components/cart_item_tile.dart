import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/cart_item.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/cart/components/cart_product_tile.dart';
import 'package:refashioned_app/screens/cart/components/delivery_data_tile.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';

class CartItemTile extends StatefulWidget {
  final CartItem cartItem;
  final Function(Product) onProductPush;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    PickPoint pickUpAddress,
    Function() onClose,
    Function(String, String) onFinish,
  }) openDeliveryTypesSelector;

  const CartItemTile(
      {Key key,
      this.cartItem,
      this.onProductPush,
      this.openDeliveryTypesSelector})
      : super(key: key);

  @override
  _CartItemTileState createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  openDeliveryTypesSelector() => widget?.openDeliveryTypesSelector?.call(
        context,
        widget.cartItem.id,
        onClose: Provider.of<CartRepository>(context, listen: false)
            .clearPendingIDs(),
        onFinish: (companyId, objectId) async {
          final cartRepository =
              Provider.of<CartRepository>(context, listen: false);

          await cartRepository.setDelivery(
              widget.cartItem.id, companyId, objectId);

          if (cartRepository.setDeliveryType?.response?.status?.code == 204) {}
        },
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final cartProduct in widget.cartItem.cartProducts)
          CartProductTile(
            cartProduct: cartProduct,
            onSelect: () {
              final result = Provider.of<CartRepository>(context, listen: false)
                  .select(cartProduct.product.id);

              if (!result) openDeliveryTypesSelector();
            },
            onProductPush: () => widget.onProductPush(cartProduct.product),
          ),
        DeliveryDataTile(
          deliveryData: widget.cartItem.deliveryData,
          deliveryCompany: widget.cartItem.deliveryCompany,
          onTap: openDeliveryTypesSelector,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ItemsDivider(
            padding: 5,
          ),
        ),
      ],
    );
  }
}
