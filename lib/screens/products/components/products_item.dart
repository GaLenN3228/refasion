import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/authorization/authorization_sheet.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/product/components/price.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductsItem extends StatefulWidget {
  final Product product;
  final GlobalKey<NavigatorState> productKey;
  final Function(Product) onPush;

  const ProductsItem({Key key, this.product, this.onPush, this.productKey}) : super(key: key);

  @override
  _ProductsItemState createState() => _ProductsItemState();
}

class _ProductsItemState extends State<ProductsItem> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2),
      child: GestureDetector(
        onTap: () => {widget.onPush(widget.product), HapticFeedback.vibrate()},
        child: new Card(
          shadowColor: Colors.transparent,
          child: Column(
            children: [
              Container(
                height: 260,
                child: Stack(
                  children: [
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
                                _controller.forward(),
                                BaseRepository.isAuthorized().then((isAuthorized) {
                                  isAuthorized
                                      ? widget.product.isFavourite
                                          ? addRemoveFavouriteRepository
                                              .removeFromFavourites((widget.product..isFavourite = false).id)
                                          : addRemoveFavouriteRepository
                                              .addToFavourites((widget.product..isFavourite = true).id)
                                      : showCupertinoModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          expand: false,
                                          context: context,
                                          useRootNavigator: true,
                                          builder: (context, controller) => AuthorizationSheet());
                                })
                              },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ScaleTransition(
                                scale: Tween(begin: 1.0, end: 1.3)
                                    .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInQuad))
                                      ..addStatusListener((status) {
                                        if (status == AnimationStatus.completed) {
                                          setState(() {
                                            _controller.reverse();
                                          });
                                        }
                                      }),
                                child: SVGIcon(
                                  color: widget.product.isFavourite ? Color(0xFFD12C2A) : Color(0xFF000000),
                                  icon:
                                      widget.product.isFavourite ? IconAsset.favoriteFilled : IconAsset.favoriteBorder,
                                  size: 26,
                                ),
                              ),
                            ),
                          ));
                    }),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Consumer<CartRepository>(
                        builder: (context, repository, child) {
                          final isInCart = repository.checkPresence(widget.product.id);

                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              if (isInCart)
                                repository.removeFromCart(widget.product.id);
                              else
                                repository.addToCart(widget.product.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                              child: SVGIcon(
                                icon: IconAsset.cart,
                                size: 26,
                                color: isInCart ? accentColor : null,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
