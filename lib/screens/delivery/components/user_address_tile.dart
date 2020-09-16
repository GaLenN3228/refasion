import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/components/radio_button/stateless.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

final _titles = {
  Delivery.PICKUP_POINT: "Пункт выдачи",
  Delivery.COURIER_DELIVERY: "Доставка по адресу",
  Delivery.EXPRESS_DEVILERY: "Доставка по адресу",
};

class UserAddressTile extends StatelessWidget {
  final UserAddress userAddress;
  final DeliveryType deliveryType;

  final Function(String) onSelect;

  final bool value;

  const UserAddressTile(
      {Key key, this.userAddress, this.deliveryType, this.value, this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onSelect != null) onSelect(userAddress.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RefashionedRadioButtonStateless(
              value: value,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        _titles[deliveryType.type].toUpperCase(),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        userAddress.address.originalAddress,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        userAddress.fio + ", " + userAddress.phone,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SVGIcon(
              icon: IconAsset.more,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
