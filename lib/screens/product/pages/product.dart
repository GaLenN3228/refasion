import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/product.dart';
import 'package:refashioned_app/screens/product/components/bottom_bar.dart';
import 'package:refashioned_app/screens/product/content/product.dart';
import 'package:refashioned_app/utils/colors.dart';

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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44.0),
          child: AppBar(
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(
                'assets/arrow_left.svg',
                height:10,
                color: primaryColor,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: ProductPageContent(),
        ),
        bottomNavigationBar: ProductBottomBar(),
      ),
    );
  }
}
