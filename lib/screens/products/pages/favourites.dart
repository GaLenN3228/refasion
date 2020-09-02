import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/products/components/products_item.dart';

class FavouritesPage extends StatelessWidget {
  final Function(Product) onPush;

  const FavouritesPage({Key key, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavouritesProductsRepository favouritesProductsRepository = context.watch<FavouritesProductsRepository>();
    if (favouritesProductsRepository.isLoading)
      return Center(
        child: Text("Загрузка", style: Theme.of(context).textTheme.bodyText1),
      );

    if (favouritesProductsRepository.loadingFailed)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    if (favouritesProductsRepository.getStatusCode != 200)
      return Center(
        child: Text("Статус", style: Theme.of(context).textTheme.bodyText1),
      );

    var favouriteProducts = favouritesProductsRepository.response.content.products;

    return CupertinoPageScaffold(
        child: Container(
            child: Column(children: [
      RefashionedTopBar(
        data: TopBarData.simple(
          onBack: () => Navigator.of(context).pop(),
          middleText: "ИЗБРАННОЕ",
        ),
      ),
      Expanded(
        child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 89),
          crossAxisCount: 2,
          itemCount: favouriteProducts.length,
          itemBuilder: (BuildContext context, int index) =>
              ProductsItem(product: favouriteProducts[index], onPush: onPush),
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 16.0,
        ),
      )
    ])));
  }
}
