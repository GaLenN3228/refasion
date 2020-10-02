import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/cart/components/tiles/delivery_object_data_tile.dart';

class OrderItemDeliveryObjectTile extends StatelessWidget {
  final UserAddress deliveryObject;
  final Delivery delivery;

  const OrderItemDeliveryObjectTile({Key key, this.deliveryObject, this.delivery}) : super(key: key);

  String addressesName() {
    switch (delivery) {
      case Delivery.PICKUP_ADDRESS:
        return "Самовывоз по адресу";

      case Delivery.PICKUP_POINT:
        switch (deliveryObject.type) {
          case UserAddressType.pickpoint:
            return "Пункт выдачи";

          case UserAddressType.boxberry_pickpoint:
            return "Пункт выдачи Boxrberry";

          default:
            return "Что-то не так";
        }
        break;

      case Delivery.COURIER_DELIVERY:
      case Delivery.EXPRESS_DEVILERY:
        return "Доставка по адресу";

      default:
        return "Что-то не так";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            addressesName().toUpperCase(),
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
