import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/delivery/components/user_address_list.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class AddressesPage extends StatefulWidget {
  final DeliveryType deliveryType;
  final List<UserAddress> userAddresses;

  final Function() onClose;
  final Function(String) onFinish;
  final Function() onAddAddress;

  const AddressesPage({
    this.onAddAddress,
    this.onClose,
    this.onFinish,
    this.deliveryType,
    this.userAddresses,
  });

  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  String callToAction;
  String emptyStateTitle;
  String bottomText;

  @override
  void initState() {
    switch (widget.deliveryType.type) {
      case Delivery.PICKUP_POINT:
        emptyStateTitle = "Нет ПВЗ";
        callToAction = "Выберите удобный пункт выдачи заказов";
        bottomText = "Чтобы выбрать доставку по адресу измените способ получения";

        break;

      case Delivery.COURIER_DELIVERY:
      case Delivery.EXPRESS_DEVILERY:
        emptyStateTitle = "Cписок адресов пуст";
        callToAction = "Выберите удобный адрес получения заказа";
        bottomText = "Чтобы выбрать доставку в пункт выдачи измените способ получения";

        break;

      default:
        emptyStateTitle = "Самовывоз?";
        callToAction = "Его тут быть не должно";

        bottomText = "Хм";
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          RefashionedTopBar(
            data: TopBarData.simple(
              middleText: "Адрес доставки",
              onClose: widget.onClose,
            ),
          ),
          Expanded(
            child: UserAddressesList(
              list: widget.userAddresses ?? [],
              deliveryType: widget.deliveryType,
              onAddAddress: widget.onAddAddress,
              onSelectAddress: (id) {
                HapticFeedback.lightImpact();

                widget.onFinish?.call(id);
              },
              emptyStateTitle: emptyStateTitle,
              callToAction: callToAction,
              bottomText: bottomText,
            ),
          ),
        ],
      ),
    );
  }
}
