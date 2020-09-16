import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class DeliveryTypeTile extends StatelessWidget {
  final DeliveryType deliveryType;

  final EdgeInsets padding;

  final Function(DeliveryType) onPush;

  const DeliveryTypeTile(
      {Key key, this.deliveryType, this.onPush, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPush?.call(deliveryType),
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            SVGIcon(
              icon: deliveryIcons[deliveryType.type],
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
                    deliveryType.name,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    deliveryType.title,
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
