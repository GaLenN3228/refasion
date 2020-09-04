import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class DeliveryOptionTile extends StatelessWidget {
  final DeliveryOptionData data;

  final Function(DeliveryType) onPush;

  const DeliveryOptionTile({Key key, this.data, this.onPush}) : super(key: key);

  IconAsset icon() {
    switch (data.deliveryType) {
      case DeliveryType.PICKUP_ADDRESS:
        return IconAsset.personThin;
      case DeliveryType.PICKUP_POINT:
        return IconAsset.location;
      case DeliveryType.COURIER_DELIVERY:
        return IconAsset.courierDelivery;
      case DeliveryType.EXPRESS_DEVILERY:
        return IconAsset.expressDelivery;
      default:
        return IconAsset.close;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPush(data.deliveryType),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            SVGIcon(
              icon: icon(),
              size: 24,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    data.subtitle,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
