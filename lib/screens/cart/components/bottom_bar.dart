import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/components/button.dart';
import 'package:refashioned_app/models/cart.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/utils/colors.dart';

class CartBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartRepository = context.watch<CartRepository>();
    if (cartRepository.isLoading) return Container();

    final Cart cart = cartRepository.cartResponse.cart;
    final numberFormat = NumberFormat("#,###", "ru_Ru");

    final bottomOffset = MediaQuery.of(context).padding.top;

    return Container(
      height: (50 + bottomOffset),
      padding: EdgeInsets.only(left: 20, right: 20, top: 7, bottom: (7 + bottomOffset)),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: lightGrayColor, width: 0)),
        color: Colors.white,
      ),
      child: Button(
        "Оформить заказ - ${numberFormat.format(cart.currentPriceAmount)} ₽",
        subTitle: "Бесплатная доставка",
        buttonStyle: ButtonStyle.dark,
        borderRadius: 5,
      ),
    );
  }
}
