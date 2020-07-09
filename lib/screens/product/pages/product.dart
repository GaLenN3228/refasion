import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/product.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';
import 'package:refashioned_app/screens/product/components/bottom_bar.dart';
import 'package:refashioned_app/screens/product/content/product.dart';

class ProductPage extends StatelessWidget {
  final Function() onPop;

  const ProductPage({Key key, this.onPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductRepository>(
      create: (_) => ProductRepository("89e8bf1f-dd00-446c-8bce-4a5e9a31586a"),
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
                child: ProductPageContent(),
              )
            ],
          ),
        ),
        bottomNavigationBar: ProductBottomBar(),
      ),
    );
  }
}
