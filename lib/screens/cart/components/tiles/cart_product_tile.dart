import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/cart_product.dart';
import 'package:refashioned_app/repositories/cart/cart.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/components/product/brand.dart';
import 'package:refashioned_app/screens/components/product/price_tile.dart';
import 'package:refashioned_app/screens/components/product/size.dart';
import 'package:refashioned_app/screens/components/product/state_tile.dart';
import 'package:refashioned_app/screens/components/checkbox/checkbox_listenable.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog_item.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog.dart' as CustomDialog;

class CartProductTile extends StatefulWidget {
  final CartProduct cartProduct;
  final Function() onProductPush;
  final Function() onSelect;

  const CartProductTile({this.cartProduct, this.onProductPush, this.onSelect});

  @override
  _CartProductTileState createState() => _CartProductTileState();
}

class _CartProductTileState extends State<CartProductTile> {
  AddRemoveFavouriteRepository addRemoveFavouriteRepository;

  CartRepository cartRepository;

  @override
  initState() {
    addRemoveFavouriteRepository = AddRemoveFavouriteRepository();

    cartRepository = Provider.of<CartRepository>(context, listen: false);

    super.initState();
  }

  @override
  dispose() {
    addRemoveFavouriteRepository = AddRemoveFavouriteRepository();

    super.dispose();
  }

  addToFavorites() async =>
      await addRemoveFavouriteRepository.addToFavourites((widget.cartProduct.product..isFavourite = true).id);

  removeFromCart() async => await cartRepository.removeFromCart(widget.cartProduct.id);

  dialog({bool isReserved: false}) {
    return showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog.Dialog(
        dialogContent: [
          if (isReserved)
            DialogItemContent(
              DialogItemType.infoHeader,
              title: "Товар в резерве",
              subTitle: "Извините, но этот товар уже оплатил другой покупатель",
            ),
          if (!isReserved)
            DialogItemContent(
              DialogItemType.item,
              title: "Подробнее",
              onClick: widget.onProductPush?.call,
              icon: IconAsset.info,
            ),
          if (!widget.cartProduct.product.isFavourite)
            DialogItemContent(
              DialogItemType.item,
              title: "Перенести в избранное",
              onClick: () async {
                await addToFavorites();
                await removeFromCart();
              },
              asyncOnClck: true,
              icon: IconAsset.favoriteBorder,
            ),
          DialogItemContent(
            DialogItemType.item,
            title: "Удалить из корзины",
            onClick: () async => await removeFromCart(),
            asyncOnClck: true,
            icon: IconAsset.delete,
            color: Colors.red,
          ),
          DialogItemContent(
            DialogItemType.system,
            title: "Отменить",
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.cartProduct.product;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (product.available)
          widget.onSelect();
        else
          dialog(isReserved: !product.available);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: RefashionedCheckboxListenable(
                  valueNotifier: widget.cartProduct.selected,
                  enabled: product.available,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.image != null
                        ? product.image
                        : "https://admin.refashioned.ru/media/product/2c8cb353-4feb-427d-9279-d2b75f46d786/2b22b56279182fe9bedb1f246d9b44b7.JPG",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductStateTile(
                        product: product,
                        padding: const EdgeInsets.only(bottom: 4),
                      ),
                      ProductPriceTile(
                        product: product,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      ProductBrandTile(
                        product: product,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      ProductSizeTile(
                        product: product,
                        padding: const EdgeInsets.only(top: 4),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => dialog(isReserved: !product.available),
                child: Container(
                  height: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SVGIcon(
                      icon: IconAsset.more,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
