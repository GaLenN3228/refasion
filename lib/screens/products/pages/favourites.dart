import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/products/components/products_item.dart';
import 'package:refashioned_app/utils/colors.dart';

class FavouritesPage extends StatefulWidget {
  final Function(Product) onPush;
  final Function() onCatalogPush;

  const FavouritesPage({Key key, this.onPush, this.onCatalogPush}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  Widget loadIcon;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    loadIcon = SizedBox(width: 25.0, height: 25.0, child: const CupertinoActivityIndicator());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          RefashionedTopBar(
            data: TopBarData.simple(
              onBack: () => Navigator.of(context).pop(),
              middleText: "ИЗБРАННОЕ",
            ),
          ),
          Consumer<FavouritesProductsRepository>(builder: (context, favouritesProductsRepository, child) {
            if (favouritesProductsRepository.isLoading && favouritesProductsRepository.response == null)
              return Center(
                  child: SizedBox(
                height: 32.0,
                width: 32.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: accentColor,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ));

            if (favouritesProductsRepository.loadingFailed)
              return Center(
                child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
              );

            var favouriteProducts = favouritesProductsRepository.response.content.products;

            if (favouriteProducts.isEmpty)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SVGIcon(
                        icon: IconAsset.favoriteBorder,
                        size: 48,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        width: 250,
                        child: Text(
                          "Избранных товаров нет",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        width: 230,
                        child: Text(
                          "Добавьте товары в избранное для быстрого доступа к ним",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: widget.onCatalogPush?.call,
                        child: Container(
                          width: 180,
                          height: 35,
                          decoration: ShapeDecoration(
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Перейти в каталог".toUpperCase(),
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );

            return Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: ClassicHeader(
                  completeDuration: Duration.zero,
                  completeIcon: null,
                  completeText: "",
                  idleIcon: loadIcon,
                  idleText: "Обновление",
                  refreshingText: "Обновление",
                  refreshingIcon: loadIcon,
                  releaseIcon: loadIcon,
                  releaseText: "Обновление",
                ),
                controller: _refreshController,
                onRefresh: () async {
                  HapticFeedback.heavyImpact();
                  await favouritesProductsRepository.getFavouritesProducts();
                  _refreshController.refreshCompleted();
                },
                child: StaggeredGridView.countBuilder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 89),
                  crossAxisCount: 2,
                  itemCount: favouriteProducts.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ProductsItem(product: favouriteProducts[index], onPush: widget.onPush),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                  mainAxisSpacing: 16.0,
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
