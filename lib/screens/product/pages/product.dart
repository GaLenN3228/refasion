import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/product.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';
import 'package:refashioned_app/screens/product/components/bottom_bar.dart';
import 'package:refashioned_app/screens/product/content/product.dart';

class ProductPage extends StatelessWidget {
  final Function() onPop;
  final String id;

  const ProductPage({Key key, this.onPop, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductRepository>(
      create: (_) => ProductRepository(id),
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
