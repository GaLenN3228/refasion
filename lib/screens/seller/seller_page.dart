import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';

class SellerPage extends StatelessWidget {
  final Seller seller;
  final Function(Product) onProductPush;

  const SellerPage({Key key, this.seller, this.onProductPush})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text(
          seller.name,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
