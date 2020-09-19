import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/delivery/components/delivery_option_tile.dart';

class ProductDelivery extends StatelessWidget {
  final Product product;

  const ProductDelivery({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product.deliveryTypes == null || product.deliveryTypes.isEmpty)
      return SizedBox();

    final pickUpAddressDeliveryIndex = product.deliveryTypes?.indexWhere(
            (deliveryType) => deliveryType.type == Delivery.PICKUP_ADDRESS) ??
        -1;

    DeliveryType pickUpAddressDelivery;

    List<DeliveryType> otherDeliveries;

    if (pickUpAddressDeliveryIndex >= 0) {
      if (product.pickUpAddress != null)
        pickUpAddressDelivery =
            product.deliveryTypes.elementAt(pickUpAddressDeliveryIndex);

      otherDeliveries = [...product.deliveryTypes]
        ..removeAt(pickUpAddressDeliveryIndex);
    } else
      otherDeliveries = product.deliveryTypes;

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
        if (pickUpAddressDelivery != null)
          Column(
            children: [
              DeliveryTypeTile(
                deliveryType: pickUpAddressDelivery,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Row(
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
            children: otherDeliveries
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
