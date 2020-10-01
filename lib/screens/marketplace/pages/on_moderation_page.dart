import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';

class OnModerationPage extends StatelessWidget {
  final Function() onClose;
  final ProductData productData;

  const OnModerationPage({Key key, this.onClose, this.productData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AddProductRepository().addProduct(productData);
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          RefashionedTopBar(
            data: TopBarData.simple(
              middleText: "На модерации",
              onClose: onClose,
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onClose,
                  child: Text(
                    "Спасибо!",
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
