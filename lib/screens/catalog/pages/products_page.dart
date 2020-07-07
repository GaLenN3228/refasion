import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';

class ProductsPage extends StatelessWidget {
  final Function(Product) onPush;
  final Function() onPop;

  const ProductsPage({Key key, this.onPush, this.onPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopPanel(
          canPop: true,
          onPop: onPop,
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onPush(null),
            child: Center(
              child: Text("Товары"),
            ),
          ),
        ),
      ],
    );
  }
}
