import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/cart/components/notification.dart';
import 'package:refashioned_app/screens/cart/components/price_total.dart';
import 'package:refashioned_app/screens/cart/components/product.dart';
import 'package:refashioned_app/screens/cart/components/promo.dart';
import 'package:refashioned_app/screens/cart/components/seller.dart';

class CartPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartRepository cartRepository = context.watch<CartRepository>();
    if (cartRepository.isLoading)
      return Center(
        child: Text("Загрузка"),
      );

    if (cartRepository.loadingFailed)
      return Center(
        child: Text("Ошибка"),
      );

    if (cartRepository.cartResponse.status.code != 200)
      return Center(
        child: Text("Иной статус"),
      );

    final Cart cart = cartRepository.cartResponse.cart;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        Text('Всего ${cart.productsCounts} товара на сумму ${cart.currentPriceAmount} Р',
            style: Theme.of(context).textTheme.headline2),
        CartNotification(cart.cartItems.length),
        for (final cartItem in cart.cartItems)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CartSeller(cartItem.seller),
              for (final product in cartItem.products) CartProduct(product)
            ],
          ),
        CartPromo(),
        CartPriceTotal(
            currentPriceAmount: cart.currentPriceAmount,
            discountPriceAmount: cart.discountPriceAmount)
      ],
    );
  }
}
