import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/cart/components/bottom_bar.dart';
import 'package:refashioned_app/screens/cart/content/cart.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class CartPage extends StatefulWidget {
  final bool needUpdate;

  final Function(Product) onProductPush;

  const CartPage({Key key, this.needUpdate, this.onProductPush})
      : super(key: key);

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
              RefashionedTopBar(
                data: TopBarData(middleData: TBMiddleData.title("Корзина")),
              ),
              Expanded(
                child: CartPageContent(
                    needUpdate: widget.needUpdate,
                    onProductPush: widget.onProductPush),
              )
            ],
          ),
        ),
        bottomNavigationBar: CartBottomBar(),
      ),
    );
  }
}
