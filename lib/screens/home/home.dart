import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refashioned_app/models/home.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/home.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/product/components/price.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/utils/colors.dart';

class HomePage extends StatefulWidget {
  static const String BANNERS = "BANNERS";
  static const String PRODUCTS = "PRODUCTS";
  static const String STORIES = "STORIES";

  final Function(Product) pushProduct;
  final Function(String url, String title) pushCollection;

  HomePage({Key key, this.pushProduct, this.pushCollection}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextTheme textTheme;

  Widget loadIcon;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final homeRepository = context.watch<HomeRepository>();

    if (homeRepository.isLoading && homeRepository.response == null)
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

    if (homeRepository.loadingFailed)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    textTheme = Theme.of(context).textTheme;
    loadIcon = SizedBox(width: 25.0, height: 25.0, child: const CupertinoActivityIndicator());

    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: Container(
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
              await homeRepository.getHomePage();
              _refreshController.refreshCompleted();
            },
            child: CustomScrollView(
              slivers: [
                ...homeRepository.response.content.blocks,
              ].map(
                (block) {
                  switch (block.type) {
                    case HomePage.PRODUCTS:
                      return SliverPadding(
                        padding: EdgeInsets.only(
                          bottom: 80,
                        ),
                        sliver: SliverToBoxAdapter(child: _productsBlockList(context, block)),
                      );
                    case HomePage.BANNERS:
                      return SliverToBoxAdapter(child: _bannersList(context, block));
                    case HomePage.STORIES:
                      return SliverToBoxAdapter(child: _storiesList(context, block));
                  }
                },
              ).toList(),
            ),
          ),
        ));
  }

  Widget _storiesList(context, HomeBlock homeBlock) {
    return Material(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          bottom: 20,
        ),
        height: MediaQuery.of(context).copyWith().size.width * 0.35,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverPadding(
                padding: EdgeInsets.only(left: 14, right: 14),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      ...homeBlock.items,
                    ].map(
                      (blockItem) {
                        return _storiesListItem(context, blockItem);
                      },
                    ).toList(),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _bannersList(context, HomeBlock homeBlock) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(bottom: 25),
        color: Colors.white,
        height: MediaQuery.of(context).copyWith().size.width * 0.6,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverPadding(
                padding: EdgeInsets.only(left: 14, right: 14),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      ...homeBlock.items,
                    ].map(
                      (blockItem) {
                        return _bannersListItem(context, blockItem);
                      },
                    ).toList(),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _productsBlockList(context, HomeBlock homeBlock) {
    return Material(
        child: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...homeBlock.items,
                ].map(
                  (blockItem) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 20, bottom: 20),
                              child: Text(
                                blockItem.name,
                                style: textTheme.headline2,
                              )),
                          _productsList(context, blockItem),
                        ]);
                  },
                ).toList())));
  }

  Widget _productsList(context, HomeBlockItem homeBlockItem) {
    return Material(
      child: Container(
        color: Colors.white,
        height: 245,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          slivers: [
            SliverPadding(
                padding: EdgeInsets.only(left: 14, right: 14),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [...homeBlockItem.products].map((product) {
                      return _productsListItem(context, product);
                    }).toList(),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _productsListItem(context, Product product) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.only(right: 6, left: 6),
      child: Tapable(
        onTap: () {
          widget.pushProduct(product);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.image,
              width: 110,
              fit: BoxFit.cover,
              height: 160,
            ),
            SizedBox(height: 4),
            SizedBox(
              width: 100,
              child: Text(
                product.brand.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.subtitle1,
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 5, bottom: 8),
                child: Text('Москва', style: textTheme.caption)),
            ProductPrice(
              product: product,
            ),
          ],
        ),
      ),
    );
  }

  Widget _storiesListItem(context, HomeBlockItem homeBlockItem) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Tapable(
      onTap: () {
        widget.pushCollection(homeBlockItem.url, homeBlockItem.name);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 4, left: 4),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35.0),
              child: Image.network(
                homeBlockItem.image,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                homeBlockItem.name,
                style: textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannersListItem(context, HomeBlockItem homeBlockItem) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, left: 6),
      child: Tapable(
        onTap: () {
          widget.pushCollection(homeBlockItem.url, homeBlockItem.name);
        },
        child: Container(
          child: Image.network(
            homeBlockItem.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
