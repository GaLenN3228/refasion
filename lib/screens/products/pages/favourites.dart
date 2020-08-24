import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/products.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/products/components/products_item.dart';

class FavouritesPage extends StatelessWidget {
  final Function(Product) onPush;

  const FavouritesPage({Key key, this.onPush}) : super(key: key);

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

    if (productsRepository.getStatusCode != 200)
      return Center(
        child: Text("Статус", style: Theme.of(context).textTheme.bodyText1),
      );

    final ProductsContent productsContent = productsRepository.response.content;

    var favouriteProducts = productsContent.products.where((element) => element.isFavourite == true).toList();

    return CupertinoPageScaffold(
        child: Container(
            child: Column(children: [
      RefashionedTopBar(
        leftButtonType: TBButtonType.icon,
        leftButtonIcon: TBIconType.back,
        leftButtonAction: () => Navigator.of(context).pop(),
        middleType: TBMiddleType.title,
        middleTitleText: "ИЗБРАННОЕ",
        bottomType: TBBottomType.none,
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
