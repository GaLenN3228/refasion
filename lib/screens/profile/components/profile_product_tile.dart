import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
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
  dialog() => showDialog(
        context: context,
        builder: (dialogContext) {
          List<DialogItemContent> dialogContent = [];

          if (widget.product.state == ProductState.published)
            dialogContent = [
              DialogItemContent(
                DialogItemType.item,
                title: "Подробнее",
                onClick: () => widget.onProductPush?.call(widget.product),
                icon: IconAsset.info,
              ),
              DialogItemContent(
                DialogItemType.item,
                title: "Снять с публикации",
                icon: IconAsset.remove_from_publication,
              ),
              DialogItemContent(
                DialogItemType.system,
                title: "Отменить",
              )
            ];
          else if (widget.product.state == ProductState.onModeration)
            dialogContent = [
              DialogItemContent(
                DialogItemType.infoHeader,
                title: "Товар на модерации",
                subTitle: "Проверка может занимать до 24-х часов",
              ),
              DialogItemContent(
                DialogItemType.item,
                title: "Удалить",
                icon: IconAsset.delete,
                color: Colors.red,
              ),
              DialogItemContent(
                DialogItemType.system,
                title: "Отменить",
              ),
            ];

          return CustomDialog.Dialog(
            dialogContent: dialogContent,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: dialog,
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
                        showAllStates: true,
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
