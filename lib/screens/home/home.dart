import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/home.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  static const String BANNERS = "BANNERS";
  static const String PRODUCTS = "PRODUCTS";
  static const String STORIES = "STORIES";

  final HomeContent homeContent;
  TextTheme textTheme;

  final Function(Product) pushProduct;
  final Function(String url) pushCollection;

  HomePage({Key key, this.homeContent, this.pushProduct, this.pushCollection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  ...homeContent.blocks,
                ].map(
                  (block) {
                    switch (block.type) {
                      case PRODUCTS:
                        return SliverToBoxAdapter(child: _productsBlockList(context, block));
                      case BANNERS:
                        return SliverToBoxAdapter(child: _bannersList(context, block));
                      case STORIES:
                        return SliverToBoxAdapter(child: _storiesList(context, block));
                    }
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storiesList(context, HomeBlock homeBlock) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(
          bottom: 20,
        ),
        height: MediaQuery.of(context).copyWith().size.width * 0.35,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  ...homeBlock.items,
                ].map(
                  (blockItem) {
                    return _storiesListItem(context, blockItem);
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannersList(context, HomeBlock homeBlock) {
    CarouselController buttonCarouselController = CarouselController();
    return Material(
      child: Container(
        child: CarouselSlider(
          carouselController: buttonCarouselController,
          items: [
            ...homeBlock.items,
          ].map(
            (blockItem) {
              return _bannersListItem(context, blockItem);
            },
          ).toList(),
          options: CarouselOptions(autoPlay: false, enableInfiniteScroll: false),
        ),
      ),
    );
  }

  Widget _productsBlockList(context, HomeBlock homeBlock) {
    return Column(
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
                      padding: EdgeInsets.only(left: 20, top: 25, bottom: 25),
                      child: Text(
                        blockItem.name,
                        style: textTheme.headline2,
                      )),
                  _productsList(context, blockItem),
                ]);
          },
        ).toList());
  }

  Widget _productsList(context, HomeBlockItem homeBlockItem) {
    return Material(
      child: Container(
        color: Colors.white,
        height: 200,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [...homeBlockItem.products].map((product) {
                  return _productsListItem(context, product);
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _productsListItem(context, Product product) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: Tapable(
        onTap: () {
          pushProduct(product);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.image,
              width: 100,
              fit: BoxFit.cover,
              height: 140,
            ),
            SizedBox(height: 4),
            SizedBox(
              width: 100,
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.subtitle1,
              ),
            ),
            Container(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Москва')),
            Text(
              product.currentPrice.toString(),
              style: textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _storiesListItem(context, HomeBlockItem homeBlockItem) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Tapable(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
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
      padding: const EdgeInsets.only(right: 10),
      child: Tapable(
        onTap: () {},
        child: Container(
          color: Color(0xFFD4EAFF),
          child: Image.network(
            homeBlockItem.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
