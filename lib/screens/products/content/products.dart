import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/products.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/products/components/products_item.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductsPageContent extends StatelessWidget {
  final Product product;
  final Function(Product) onPush;
  final GlobalKey<NavigatorState> productKey;

  const ProductsPageContent({Key key, this.onPush, this.product, this.productKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsRepository productsRepository = context.watch<ProductsRepository>();
    if (productsRepository.isLoading)
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: accentColor,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      );

    if (productsRepository.loadingFailed)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    final ProductsContent productsContent = productsRepository.response.content;

    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 89),
      crossAxisCount: 2,
      itemCount: productsContent.products.length,
      itemBuilder: (BuildContext context, int index) =>
          ProductsItem(productKey: productKey, product: productsContent.products[index], onPush: onPush),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 16.0,
    );
  }
}
