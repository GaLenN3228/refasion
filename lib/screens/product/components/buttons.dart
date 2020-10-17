import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/cart/cart.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/product/components/add_to_cart_button.dart';
import 'package:refashioned_app/screens/product/components/order_now_button.dart';

class ProductBottomButtons extends StatefulWidget {
  final Product product;
  final Function() onCartPush;
  final Function() openDeliveryTypesSelector;

  const ProductBottomButtons({this.product, this.onCartPush, this.openDeliveryTypesSelector});
  @override
  _ProductBottomButtonsState createState() => _ProductBottomButtonsState();
}

class _ProductBottomButtonsState extends State<ProductBottomButtons> {
  CartRepository cartRepository;

  RBState addToCartButtonState;
  RBState orderNowButtonState;

  @override
  void initState() {
    cartRepository = Provider.of<CartRepository>(context, listen: false);

    addToCartButtonState = RBState.disabled;
    orderNowButtonState = RBState.disabled;

    if (cartRepository != null) addToCartButtonState = RBState.enabled;

    if (cartRepository.checkPresence(widget.product.id)) addToCartButtonState = RBState.done;

    if (widget.product.available) orderNowButtonState = RBState.enabled;

    super.initState();
  }

  addToCart() async {
    HapticFeedback.heavyImpact();

    setState(() => addToCartButtonState = RBState.loading);

    await cartRepository?.addToCart(widget.product.id);

    final repository = cartRepository.addProduct;

    if (repository.lastProductId == widget.product.id) {
      setState(
        () {
          if (repository.isLoaded)
            addToCartButtonState = RBState.done;
          else
            addToCartButtonState = RBState.disabled;
        },
      );
    }
  }

  orderNow() async {
    setState(() => orderNowButtonState = RBState.loading);

    await widget.openDeliveryTypesSelector?.call();

    final newState = widget.product.available ? RBState.enabled : RBState.disabled;

    setState(() => orderNowButtonState = newState);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product == null) return SizedBox();

    return Row(
      children: <Widget>[
        Expanded(
          child: OrderNowButton(
            padding: const EdgeInsets.only(left: 20),
            onEnabledPush: orderNow,
            state: orderNowButtonState,
          ),
        ),
        Container(
          width: 5,
        ),
        Expanded(
          child: AddToCartButton(
            padding: const EdgeInsets.only(right: 20),
            onEnabledPush: addToCart,
            onDonePush: widget.onCartPush?.call,
            state: addToCartButtonState,
          ),
        ),
      ],
    );
  }
}
