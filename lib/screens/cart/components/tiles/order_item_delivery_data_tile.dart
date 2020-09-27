import 'package:flutter/material.dart';
import 'package:refashioned_app/models/pick_point.dart';

class OrderItemDeliveryDataTile extends StatelessWidget {
  final PickPoint deliveryObject;

  const OrderItemDeliveryDataTile({Key key, this.deliveryObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 7.5),
      child: RichText(
        text: TextSpan(
          text: "Адрес: ",
          style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.6),
          children: [
            TextSpan(
              text: deliveryObject.originalAddress,
              style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
