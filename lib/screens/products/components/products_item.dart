import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/add_cart.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/cart_count.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/product/components/price.dart';
import 'package:refashioned_app/screens/profile/profile.dart';
import 'package:refashioned_app/utils/url.dart';
import 'package:provider/provider.dart';

class ProductsItem extends StatefulWidget {
  final Product product;
  final Function(Product) onPush;

  const ProductsItem({Key key, this.product, this.onPush}) : super(key: key);

  @override
  _ProductsItemState createState() => _ProductsItemState();
}

class _ProductsItemState extends State<ProductsItem> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: GestureDetector(
          onTap: () => {
            widget.onPush(widget.product),
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
                      widget.product.image != null
                          ? widget.product.image
                          : "https://admin.refashioned.ru/media/product/2c8cb353-4feb-427d-9279-d2b75f46d786/2b22b56279182fe9bedb1f246d9b44b7.JPG",
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Consumer<AddRemoveFavouriteRepository>(builder: (context, addRemoveFavouriteRepository, child) {
                    return GestureDetector(
                        onTap: () => {
                          BaseRepository.isAuthorized().then((isAuthorized) {
                            isAuthorized
                                ? widget.product.isFavourite
                                ? addRemoveFavouriteRepository.removeFromFavourites((widget.product..isFavourite = false).id)
                                : addRemoveFavouriteRepository.addToFavourites((widget.product..isFavourite = true).id)
                                : showCupertinoModalBottomSheet(
                                backgroundColor: Colors.white,
                                expand: false,
                                context: context,
                                useRootNavigator: true,
                                builder: (context, controller) => ProfilePage());
                          })
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, right: 14),
                            child: SvgPicture.asset(
                              widget.product.isFavourite ? 'assets/favorite_red.svg' : 'assets/favorite_border.svg',
                              width: 22,
                              height: 22,
                            ),
                          ),
                        ));
                  }),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () => {
                        HapticFeedback.mediumImpact(),
                        AddCartRepository()
                          ..addToCart(widget.product.id)
                          ..addListener(() {
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
                  widget.product.brand.name,
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
                  discountPrice: widget.product.discountPrice,
                  currentPrice: widget.product.currentPrice,
                ),
              )
            ]),
          ),
        ));
  }
}
