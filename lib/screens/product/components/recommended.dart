import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/products.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/products/components/products_item.dart';

class RecommendedProducts extends StatelessWidget {
  final Product product;
  final Function(Product) onPush;

  const RecommendedProducts({Key key, this.product, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsRepository productsRepository = context.watch<ProductsRepository>();
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

    final ProductsContent productsContent = productsRepository.productsResponse.productsContent;

    return StaggeredGridView.countBuilder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      crossAxisCount: 2,
      itemCount: productsContent.products.length,
      itemBuilder: (BuildContext context, int index) => ProductsItem(
        product: productsContent.products[index],
        onPush: (product) => onPush(product),
      ),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 16.0,
    );
  }
}