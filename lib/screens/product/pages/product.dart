import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/product.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';
import 'package:refashioned_app/screens/product/components/bottom_bar.dart';
import 'package:refashioned_app/screens/product/content/product.dart';

class ProductPage extends StatelessWidget {
  final String id;

  const ProductPage({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductRepository>(
      create: (_) => ProductRepository(id),
      child: CupertinoPageScaffold(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                TopPanel(
                  canPop: true,
                  type: PanelType.item,
                ),
                Expanded(
                  child: ProductPageContent(),
                )
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ProductBottomBar(),
            )
          ],
        ),
      ),
    );
  }
}
