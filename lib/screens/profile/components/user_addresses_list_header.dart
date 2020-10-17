import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/profile/components/user_address_tile.dart';

class UserAddressesListHeader extends StatelessWidget {
  final UserAddressesListType type;

  const UserAddressesListHeader({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == UserAddressesListType.pickup) return SizedBox();

    IconAsset icon;
    String title;

    switch (type) {
      case UserAddressesListType.delivery:
        icon = IconAsset.courierDelivery;
        title = "Доставка курьером";
        break;

      case UserAddressesListType.pickpoint:
        icon = IconAsset.location;
        title = "Доставка в пункт выдачи";
        break;

      default:
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Row(
        children: [
          SVGIcon(
            icon: icon,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline1,
            ),
          )
        ],
      ),
    );
  }
}
