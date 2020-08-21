import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/add_cart.dart';
import 'package:refashioned_app/repositories/cart_count.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/product/components/price.dart';
import 'package:refashioned_app/screens/profile/profile.dart';
import 'package:refashioned_app/utils/url.dart';
import 'package:provider/provider.dart';

class ProductsItem extends StatelessWidget {
  final Product product;
  final Function(Product) onPush;

  const ProductsItem({Key key, this.product, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavouriteRepository favouriteRepository = context.watch<FavouriteRepository>();
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: GestureDetector(
          onTap: () => {
            onPush(product),
          },
          child: new Card(
            shadowColor: Colors.transparent,
            child: Column(children: [
              Container(
                height: 260,
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      product.image != null
                          ? product.image
                          : "https://admin.refashioned.ru/media/product/2c8cb353-4feb-427d-9279-d2b75f46d786/2b22b56279182fe9bedb1f246d9b44b7.JPG",
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                      onTap: () => {
//                            showCupertinoModalBottomSheet(
//                                backgroundColor: Colors.white,
//                                expand: false,
//                                context: context,
//                                useRootNavigator: true,
//                                builder: (context, controller) => ProfilePage())
                            favouriteRepository.addToFavourites(product.id)
                          },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, right: 2),
                          child: SvgPicture.asset(
                            'assets/favorite_border.svg',
                            color: Colors.black,
                            width: 40,
                            height: 40,
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () => {
                        AddCartRepository(product.id).addListener(() {
                          CartCountRepository.notify(context, Uri.parse(Url.cartItem));
                        })
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14, right: 14),
                        child: SvgPicture.asset(
                          'assets/bag.svg',
                          color: Colors.black,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 6.0),
                child: Text(
                  product.brand.name,
                  style: textTheme.subtitle1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 2.0),
                child: Text(
                  "Москва",
                  style: textTheme.caption,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6.0),
                child: ProductPrice(
                  discountPrice: product.discountPrice,
                  currentPrice: product.currentPrice,
                ),
              )
            ]),
          ),
        ));
  }
}
