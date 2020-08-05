import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/cart/components/bottom_bar.dart';
import 'package:refashioned_app/screens/cart/content/cart.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';

class CartPage extends StatefulWidget {
  final bool needUpdate;

  const CartPage({Key key, this.needUpdate}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
  }

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
                canPop: false,
                type: PanelType.item,
              ),
              Expanded(
                child: CartPageContent(needUpdate: widget.needUpdate),
              )
            ],
          ),
        ),
        bottomNavigationBar: CartBottomBar(),
      ),
    );
  }
}
