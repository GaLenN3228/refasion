import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/cart/cart.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/components/product/brand.dart';
import 'package:refashioned_app/screens/components/product/price_tile.dart';
import 'package:refashioned_app/screens/components/product/size.dart';
import 'package:refashioned_app/screens/components/product/state_tile.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog_item.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog.dart' as CustomDialog;

class ProfileProductTile extends StatefulWidget {
  final Product product;
  final Function(Product) onProductPush;

  const ProfileProductTile({this.product, this.onProductPush});

  @override
  _ProfileProductTileState createState() => _ProfileProductTileState();
}

class _ProfileProductTileState extends State<ProfileProductTile> {
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

  addToFavorites() async => await addRemoveFavouriteRepository.addToFavourites((widget.product..isFavourite = true).id);

  removeFromCart() async => await cartRepository.removeFromCart(widget.product.id);

  dialog() {
    return showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog.Dialog(
        dialogContent: [
          if (widget.product.state == ProductState.published)
            DialogItemContent(
              DialogItemType.item,
              title: "Подробнее",
              onClick: () {
                Navigator.of(dialogContext).pop();
                widget.onProductPush?.call(widget.product);
              },
              icon: IconAsset.info,
            ),
          if (widget.product.state == ProductState.published)
            DialogItemContent(
              DialogItemType.item,
              title: "Снять с публикации",
              onClick: () {},
              icon: IconAsset.remove_from_publication,
            ),
          if (widget.product.state == ProductState.onModeration)
            DialogItemContent(
              DialogItemType.infoHeader,
              title: "Товар на модерации",
              subTitle: "Проверка может занимать до 24-х часов",
            ),
          if (widget.product.state == ProductState.onModeration)
            DialogItemContent(
              DialogItemType.item,
              title: "Удалить",
              onClick: () async {
                await removeFromCart();

                Navigator.of(dialogContext).pop();
              },
              icon: IconAsset.delete,
              color: Colors.red,
            ),
          DialogItemContent(
            DialogItemType.system,
            title: "Отменить",
            onClick: () => Navigator.of(dialogContext).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        dialog();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
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
                      ProductStateTile(product: product, showAllStates: true),
                      ProductPriceTile(product: product),
                      ProductBrandTile(product: product),
                      ProductSizeTile(
                        product: product,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
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
