import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/products/components/products_item.dart';

class RecommendedProducts extends StatelessWidget {
  final Product product;
  final Function(Product) onProductPush;

  const RecommendedProducts({Key key, this.product, this.onProductPush})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductRecommendedRepository>(
      create: (_) =>
          ProductRecommendedRepository()..getProductRecommended(product.id),
      child: Consumer<ProductRecommendedRepository>(
        builder: (context, repository, _) {
          final products = repository?.response?.content;

          if (products != null && products.isNotEmpty)
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ItemsDivider(
                    padding: 0,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ВАМ МОЖЕТ ПОНРАВИТЬСЯ",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                StaggeredGridView.countBuilder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 15),
                  crossAxisCount: 2,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ProductsItem(
                          product: products[index], onPush: onProductPush),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                  mainAxisSpacing: 15,
                ),
              ],
            );
          else
            return SizedBox();
        },
      ),
    );
  }
}
