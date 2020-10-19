import 'package:flutter/material.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/marketplace/components/border_button.dart';
import 'package:refashioned_app/screens/profile/components/user_address_tile.dart';
import 'package:refashioned_app/screens/profile/components/user_addresses_list_header.dart';
import 'package:refashioned_app/utils/colors.dart';

class UserAddressesList extends StatefulWidget {
  final List<UserAddress> allUserAddresses;

  final UserAddressesListType type;

  final Function() onNewUserAddressPush;

  const UserAddressesList({
    Key key,
    this.allUserAddresses,
    this.type,
    this.onNewUserAddressPush,
  }) : super(key: key);
  @override
  _UserAddressesListState createState() => _UserAddressesListState();
}

class _UserAddressesListState extends State<UserAddressesList> {
  List<UserAddress> userAddresses;

  @override
  initState() {
    switch (widget.type) {
      case UserAddressesListType.pickup:
        userAddresses = widget.allUserAddresses.where((element) => element.type == UserAddressType.address).toList();
        break;

      case UserAddressesListType.delivery:
        userAddresses = widget.allUserAddresses.where((element) => element.type == UserAddressType.address).toList();
        break;

      case UserAddressesListType.pickpoint:
        userAddresses = widget.allUserAddresses
            .where((element) =>
                element.type == UserAddressType.pickpoint || element.type == UserAddressType.boxberry_pickpoint)
            .toList();
        break;

      default:
        userAddresses = [];
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAddressesListHeader(type: widget.type),
        if (userAddresses.isNotEmpty)
          ...userAddresses
              .map(
                (userAddress) => UserAddressTile(
                  userAddress: userAddress,
                  type: widget.type,
                ),
              )
              .toList(),
        if (userAddresses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Список адресов пуст",
              style: Theme.of(context).textTheme.bodyText1.copyWith(color: darkGrayColor),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: SizedBox(
                width: 150,
                child: BorderButton(
                  type: BorderButtonType.newAddress,
                  onTap: widget.onNewUserAddressPush,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}
