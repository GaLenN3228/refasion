import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/cart_item.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/addresses.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/cart/cart/components/cart_product_tile.dart';
import 'package:refashioned_app/screens/cart/delivery/components/delivery_options_panel.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class CartGroup extends StatefulWidget {
  final CartItem data;
  final Function(Product) onProductPush;
  final Function(DeliveryType, PickPoint, Function()) onOptionPush;

  const CartGroup({Key key, this.data, this.onProductPush, this.onOptionPush})
      : super(key: key);
  @override
  _CartGroupState createState() => _CartGroupState();
}

class _CartGroupState extends State<CartGroup> {
  openDeliveryTypesSelector() async {
    final repository = Provider.of<CartRepository>(context, listen: false);

    await repository.getCartItemDeliveryTypes(widget.data.id);

    final options = repository?.getDeliveryTypes?.response?.content;

    // final pickUpAddressOptionIndex = options?.indexWhere(
    //     (option) => option.deliveryType == DeliveryType.PICKUP_ADDRESS);

    PickPoint pickUpAddress = PickPoint(
      address: "Офис",
      originalAddress: "пр-д Серебрякова, 4, строение 1, Москва, 129343",
      latitude: 55.846724,
      longitude: 37.647783,
    );

    // if (pickUpAddressOptionIndex != null && pickUpAddressOptionIndex >= 0) {
    //   final getAddressesRepository = GetAddressesRepository();

    //   await getAddressesRepository.update();

    //   final getAddressRepository = GetAddressRepository();

    //   final pickUpAddressDeliveryOption =
    //       options.elementAt(pickUpAddressOptionIndex);

    //   await getAddressRepository.update(pickUpAddressDeliveryOption.id);

    //   if (getAddressRepository.isLoaded &&
    //       getAddressRepository.response.status.code == 200)
    //     pickUpAddress = getAddressRepository.response.content.pickPoint;

    //   if (pickUpAddress == null) options.removeAt(pickUpAddressOptionIndex);
    // }

    if (options == null || options.isEmpty) return;

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
            () => print("pickUpAddress accepted: " + pickUpAddress.toString()),
          );
        },
        options: options,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final cartProduct in widget.data.products)
          CartProductTile(
            cartProduct: cartProduct,
            onSelect: () async {
              final result = Provider.of<CartRepository>(context, listen: false)
                  .select(cartProduct.id);

              if (!result) await openDeliveryTypesSelector();
            },
            onProductPush: () => widget.onProductPush(cartProduct.product),
          ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async => await openDeliveryTypesSelector(),
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
