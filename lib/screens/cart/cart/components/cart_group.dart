import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/cart/cart/components/product.dart';
import 'package:refashioned_app/screens/cart/cart/data/cart_data.dart';
import 'package:refashioned_app/screens/cart/delivery/components/delivery_options_panel.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CartGroup extends StatefulWidget {
  final CartGroupData data;
  final Function(Product) onProductPush;
  final Function(DeliveryType, Address, Function()) onOptionPush;

  const CartGroup({Key key, this.data, this.onProductPush, this.onOptionPush})
      : super(key: key);
  @override
  _CartGroupState createState() => _CartGroupState();
}

class _CartGroupState extends State<CartGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final product in widget.data.products)
          CartProduct(
            product: product,
            onProductPush: () => widget.onProductPush(product),
          ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final options = widget.data.availableDeliveryOptions;

            final pickUpAddress = Address(
              address: "Офис",
              originalAddress:
                  "пр-д Серебрякова, 4, строение 1, Москва, 129343",
              coordinates: Point(latitude: 55.846703, longitude: 37.647508),
            );

            if (options.isNotEmpty)
              showMaterialModalBottomSheet(
                expand: false,
                context: context,
                useRootNavigator: true,
                builder: (context, controller) => DeliveryOptionsPanel(
                  onPush: (deliveryType) {
                    Navigator.of(context).pop();
                    widget.onOptionPush(
                      deliveryType,
                      pickUpAddress,
                      () => print("pickUpAddress accepted: " +
                          pickUpAddress.toString()),
                    );
                  },
                  options: options,
                ),
              );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Выберите способ доставки",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(0xFF930012),
                      ),
                ),
                Row(
                  children: [
                    Text(
                      "Выбрать",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    RotatedBox(
                      quarterTurns: 2,
                      child: SVGIcon(
                        icon: IconAsset.back,
                        size: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ItemsDivider(
            padding: 5,
          ),
        ),
      ],
    );
  }
}
