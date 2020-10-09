import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/delivery/components/user_address_list.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class AddressesPage extends StatelessWidget {
  final List<UserAddress> userAddresses;

  final Function() onClose;
  final Function(UserAddress) onSelect;
  final Function() onAddAddress;

  const AddressesPage({this.onSelect, this.userAddresses, this.onClose, this.onAddAddress});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          RefashionedTopBar(
            data: TopBarData.simple(
              onBack: Navigator.of(context).pop,
              middleText: "Добавить вещь",
              onClose: onClose,
              bottomText: "Выберите адрес",
            ),
          ),
          Expanded(
            child: UserAddressesList(
              list: userAddresses ?? [],
              onAddAddress: onAddAddress,
              onSelectAddress: onSelect?.call,
              emptyStateTitle: "Cписок адресов пуст",
              callToAction: "Выберите удобный адрес получения заказа",
              bottomText: "Укажите удобное вам место встречи с покупателем",
            ),
          ),
        ],
      ),
    );
  }
}
