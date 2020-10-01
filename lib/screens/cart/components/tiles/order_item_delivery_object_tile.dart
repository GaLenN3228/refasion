import 'package:flutter/material.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/cart/components/tiles/delivery_object_data_tile.dart';

class OrderItemDeliveryObjectTile extends StatelessWidget {
  final UserAddress deliveryObject;

  const OrderItemDeliveryObjectTile({Key key, this.deliveryObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deliveryObject.nameForBuyer.toUpperCase(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 5,
          ),
          DeliveryObjectDataTile(
            name: "Адрес: ",
            value: deliveryObject.address.originalAddress,
          ),
          if (deliveryObject.type == UserAddressType.boxberry_pickpoint ||
              deliveryObject.type == UserAddressType.pickpoint)
            Column(
              children: [
                DeliveryObjectDataTile(
                  name: "Время работы: ",
                  value: deliveryObject.address.workSchedule,
                ),
                DeliveryObjectDataTile(
                  name: "Получатель: ",
                  value: deliveryObject.fio,
                ),
                DeliveryObjectDataTile(
                  name: "Телефон: ",
                  value: deliveryObject.phone,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
