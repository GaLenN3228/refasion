import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';
import 'package:refashioned_app/screens/delivery/components/user_address_tile.dart';
import 'package:refashioned_app/screens/marketplace/components/border_button.dart';

class UserAddressesList extends StatefulWidget {
  final List<UserAddress> list;

  final DeliveryType deliveryType;

  final String callToAction;
  final String emptyStateTitle;
  final String bottomText;

  final Function() onAddAddress;
  final Function(String) onSelectAddress;

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
  String selectedUserAddressId;

  @override
  initState() {
    if (widget.list.isNotEmpty) selectedUserAddressId = widget.list.first.id;

    super.initState();
  }

  onSelect(String id) {
    HapticFeedback.selectionClick();

    setState(() {
      selectedUserAddressId = id;
    });
  }

  onPush() {
    if (widget.onSelectAddress != null &&
        selectedUserAddressId != null &&
        selectedUserAddressId.isNotEmpty) widget.onSelectAddress(selectedUserAddressId);
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
                      value: userAddress.id == selectedUserAddressId,
                      onSelect: onSelect,
                    ))
                .toList(),
            ...[
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
                        onTap: widget.onAddAddress,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: 250,
                  child: Text(
                    widget.bottomText,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
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
            padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom),
            child: RefashionedButton(
                data: ButtonData(
                  buttonContainerData: ButtonContainerData(
                    decorationType: ButtonDecorationType.black,
                  ),
                  titleData: ButtonTitleData(
                    text: "Выбрать",
                    color: ButtonTitleColor.white,
                  ),
                ),
                onTap: onPush),
          ),
        ),
      ],
    );
  }
}
