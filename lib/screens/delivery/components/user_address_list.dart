import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/delivery/components/select_address_button.dart';
import 'package:refashioned_app/screens/delivery/components/user_address_tile.dart';
import 'package:refashioned_app/screens/marketplace/components/border_button.dart';

class UserAddressesList extends StatefulWidget {
  final List<UserAddress> list;

  final DeliveryType deliveryType;

  final String callToAction;
  final String emptyStateTitle;
  final String bottomText;

  final Function() onAddAddress;
  final Function(UserAddress) onSelectAddress;

  const UserAddressesList({
    Key key,
    this.list,
    this.callToAction,
    this.emptyStateTitle,
    this.bottomText,
    this.deliveryType,
    this.onAddAddress,
    this.onSelectAddress,
  }) : super(key: key);
  @override
  _UserAddressesListState createState() => _UserAddressesListState();
}

class _UserAddressesListState extends State<UserAddressesList> {
  UserAddress selectedUserAddressId;
  RBState buttonState;

  @override
  initState() {
    if (widget.list.isNotEmpty) {
      selectedUserAddressId = widget.list.first;
      buttonState = RBState.enabled;
    }

    super.initState();
  }

  onSelect(UserAddress userAddress) {
    HapticFeedback.selectionClick();

    setState(() {
      selectedUserAddressId = userAddress;
      buttonState = selectedUserAddressId != null ? RBState.enabled : RBState.disabled;
    });
  }

  onPush() async {
    setState(() => buttonState = RBState.loading);

    await widget.onSelectAddress?.call(selectedUserAddressId);

    setState(() => buttonState = selectedUserAddressId != null ? RBState.enabled : RBState.disabled);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 65.0),
          children: [
            ...widget.list
                .map((userAddress) => UserAddressTile(
                      userAddress: userAddress,
                      deliveryType: widget.deliveryType,
                      value: userAddress.id == selectedUserAddressId.id,
                      onSelect: onSelect,
                    ))
                .toList(),
            ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10),
                  child: SizedBox(
                    width: 150,
                    child: BorderButton(
                      type: BorderButtonType.newAddress,
                      onTap: widget.onAddAddress,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                child: Text(
                  widget.bottomText,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              )
            ]
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: SelectAddressButton(
              state: buttonState,
              onPush: onPush,
            ),
          ),
        ),
      ],
    );
  }
}
