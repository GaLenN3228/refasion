import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/cart_product.dart';
import 'package:refashioned_app/models/product.dart';
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

  dialog() {
    return showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog.Dialog(
        dialogContent: [
          DialogItemContent(
            "Подробнее",
            () {
              Navigator.of(dialogContext).pop();
              widget.onProductPush?.call();
            },
            DialogItemType.item,
            icon: IconAsset.info,
          ),
          if (!widget.cartProduct.product.isFavourite)
            DialogItemContent(
              "Перенести в избранное",
              () async {
                await addToFavorites();
                await removeFromCart();

                Navigator.of(dialogContext).pop();
              },
              DialogItemType.item,
              icon: IconAsset.favoriteBorder,
            ),
          DialogItemContent(
            "Удалить из корзины",
            () async {
              await removeFromCart();

              Navigator.of(dialogContext).pop();
            },
            DialogItemType.item,
            icon: IconAsset.delete,
            color: Colors.red,
          ),
          DialogItemContent(
            "Отменить",
            () => Navigator.of(dialogContext).pop(),
            DialogItemType.system,
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
        if (product.state == ProductState.published)
          widget.onSelect();
        else
          dialog();
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
                      ProductStateTile(product: product),
                      ProductPriceTile(product: product),
                      ProductBrandTile(product: product),
                      ProductSizeTile(product: product),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: dialog,
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
