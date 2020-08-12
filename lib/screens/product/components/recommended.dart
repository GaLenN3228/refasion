import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/products.dart';
import 'package:refashioned_app/repositories/product_recommended.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/product/pages/product.dart';
import 'package:refashioned_app/screens/products/components/products_item.dart';

class RecommendedProducts extends StatelessWidget {
  final Product product;

  const RecommendedProducts({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductRecommendedRepository productsRepository =
        context.watch<ProductRecommendedRepository>();
    if (productsRepository.isLoading)
      return Center(
        child: Text("Загрузка", style: Theme.of(context).textTheme.bodyText1),
      );

    if (productsRepository.loadingFailed)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    if (productsRepository.productsResponse.status.code != 200)
      return Center(
        child: Text("Статус", style: Theme.of(context).textTheme.bodyText1),
      );

    return StaggeredGridView.countBuilder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      crossAxisCount: 2,
      itemCount: productsRepository.productsResponse.products.length,
      itemBuilder: (BuildContext context, int index) => ProductsItem(
        product: productsRepository.productsResponse.products[index],
        onPush: (product) => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => ProductPage(id: product.id),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 16.0,
    );
  }
}
