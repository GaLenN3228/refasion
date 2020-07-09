import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/cart/components/bottom_bar.dart';
import 'package:refashioned_app/screens/cart/content/cart.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';

class CartPage extends StatelessWidget {
  final Function() onPop;

  const CartPage({Key key, this.onPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartRepository>(
      create: (_) => CartRepository(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              TopPanel(
                canPop: true,
                onPop: onPop,
                type: PanelType.item,
              ),
              Expanded(
                child: CartPageContent(),
              )
            ],
          ),
        ),
        bottomNavigationBar: CartBottomBar(),
      ),
    );
  }
}
