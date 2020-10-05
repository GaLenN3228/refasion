import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';

class OnModerationPage extends StatelessWidget {
  final Function() onProductCreated;
  final ProductData productData;

  const OnModerationPage({Key key, this.onProductCreated, this.productData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AddProductRepository().addProduct(productData);
    onProductCreated();
    return SizedBox();
    // return CupertinoPageScaffold(
    //   backgroundColor: Colors.white,
    //   child: Column(
    //     children: <Widget>[
    //       RefashionedTopBar(
    //         data: TopBarData.simple(
    //           middleText: "Добавление продукта",
    //         ),
    //       ),
    //       Expanded(
    //         child: Center(
    //           child: GestureDetector(
    //               behavior: HitTestBehavior.translucent,
    //               child: Text(
    //                 "Создание...",
    //                 style: Theme.of(context).textTheme.bodyText1,
    //               )),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
