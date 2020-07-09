import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/products.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/products/components/products_item.dart';

class ProductsPageContent extends StatelessWidget {
  final Product product;
  final Function(Product) onPush;

  const ProductsPageContent({Key key, this.onPush, this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsRepository productsRepository =
        context.watch<ProductsRepository>();
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

    final ProductsContent productsContent =
        productsRepository.productsResponse.productsContent;

    return GridView.count(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 56),
      crossAxisCount: 2,
      childAspectRatio: MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height),
//            childAspectRatio: MediaQuery.of(context).size.height / 1370,
      children:
          new List<Widget>.generate(productsContent.products.length, (index) {
        return new GridTile(
          child: ProductsItem(
              product: productsContent.products[index], onPush: onPush),
        );
      }),
    );
  }
}
