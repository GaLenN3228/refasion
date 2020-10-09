import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/cart_item.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/cart/cart.dart';
import 'package:refashioned_app/screens/cart/components/tiles/cart_product_tile.dart';
import 'package:refashioned_app/screens/cart/components/tiles/delivery_data_tile.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';

class CartItemTile extends StatefulWidget {
  final CartItem cartItem;
  final Function(Product) onProductPush;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function() onFinish,
    Future<bool> Function(String, String) onSelect,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  const CartItemTile({Key key, this.cartItem, this.onProductPush, this.openDeliveryTypesSelector}) : super(key: key);

  @override
  _CartItemTileState createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  openDeliveryTypesSelector() => widget.openDeliveryTypesSelector?.call(
        context,
        widget.cartItem.id,
        onClose: Provider.of<CartRepository>(context, listen: false).clearPendingIDs,
        onSelect: (companyId, objectId) async {
          final repository = Provider.of<CartRepository>(context, listen: false);
          final result = await repository.setDelivery(widget.cartItem.id, companyId, objectId);

          if (!result) {
            showCupertinoDialog(
              context: context,
              useRootNavigator: true,
              builder: (context) => CupertinoAlertDialog(
                title: Text(
                  "Ошибка",
                  style: Theme.of(context).textTheme.headline1,
                ),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    repository.response?.errors?.messages ?? "Неизвестная ошибка",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: Navigator.of(context).pop,
                    child: Text("ОК"),
                  )
                ],
              ),
            );
          }

          return result;
        },
        originalOverlayStyle: SystemUiOverlayStyle.light,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final cartProduct in widget.cartItem.cartProducts)
          CartProductTile(
            cartProduct: cartProduct,
            onSelect: () {
              final wasAbleToSelect =
                  Provider.of<CartRepository>(context, listen: false).select(cartProduct.product.id);

              if (!wasAbleToSelect)
                openDeliveryTypesSelector();
              else
                HapticFeedback.selectionClick();
            },
            onProductPush: () => widget.onProductPush(cartProduct.product),
          ),
        DeliveryDataTile(
          deliveryData: widget.cartItem.deliveryData,
          deliveryOption: widget.cartItem.deliveryOption,
          onTap: openDeliveryTypesSelector,
          available: widget.cartItem.available,
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
