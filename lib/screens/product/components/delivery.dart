import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/delivery/components/delivery_option_tile.dart';

class ProductDelivery extends StatelessWidget {
  final Product product;
  final Function(PickPoint) onPickupAddressPush;

  const ProductDelivery({Key key, this.product, this.onPickupAddressPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product.deliveryTypes == null || product.deliveryTypes.isEmpty) return SizedBox();

    final pickUpAddressDeliveryIndex = product.deliveryTypes
            ?.indexWhere((deliveryType) => deliveryType.type == Delivery.PICKUP_ADDRESS) ??
        -1;

    DeliveryType pickUpAddressDeliveryType;

    List<DeliveryType> otherDeliveryTypes;

    if (pickUpAddressDeliveryIndex >= 0) {
      if (product.pickUpAddress != null)
        pickUpAddressDeliveryType = product.deliveryTypes.elementAt(pickUpAddressDeliveryIndex);

      otherDeliveryTypes = [...product.deliveryTypes]..removeAt(pickUpAddressDeliveryIndex);
    } else
      otherDeliveryTypes = product.deliveryTypes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ItemsDivider(
            padding: 0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            "Доставка",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        if (pickUpAddressDeliveryType != null)
          Column(
            children: [
              DeliveryTypeTile(
                deliveryType: pickUpAddressDeliveryType,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => onPickupAddressPush
                    ?.call(pickUpAddressDeliveryType.deliveryOptions.first.deliveryObject),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              product.pickUpAddress.originalAddress,
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Показать на карте",
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/images/png/pickup_address_example.png",
                      width: 80,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ItemsDivider(
                  padding: 0,
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: otherDeliveryTypes
                .map(
                  (deliveryType) => DeliveryTypeTile(
                    deliveryType: deliveryType,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
