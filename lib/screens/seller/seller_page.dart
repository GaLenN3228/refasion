import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/screens/components/empty_page.dart';

class SellerPage extends StatelessWidget {
  final Seller seller;
  final Function(Product) onProductPush;

  const SellerPage({Key key, this.seller, this.onProductPush})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyPage(
      text: seller.name,
    );
  }
}
