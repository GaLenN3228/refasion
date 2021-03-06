import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog_item.dart';
import 'package:refashioned_app/screens/components/radio_button/stateless.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog.dart' as CustomDialog;

class UserAddressTile extends StatefulWidget {
  final UserAddress userAddress;
  final DeliveryType deliveryType;

  final Function(UserAddress) onSelect;

  final bool value;

  final bool isForSeller;

  const UserAddressTile({
    Key key,
    this.userAddress,
    this.deliveryType,
    this.value,
    this.onSelect,
    this.isForSeller: false,
  }) : super(key: key);

  @override
  _UserAddressTileState createState() => _UserAddressTileState();
}

class _UserAddressTileState extends State<UserAddressTile> {
  String addressesName() {
    switch (widget.deliveryType?.type) {
      case Delivery.PICKUP_ADDRESS:
        return "Адрес самовывоза";

      case Delivery.PICKUP_POINT:
        switch (widget.userAddress.type) {
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
        return "Адрес доставки";

      default:
        return "Адрес самовывоза";
    }
  }

  dialog() => showDialog(
        context: context,
        builder: (dialogContext) => CustomDialog.Dialog(
          dialogContent: [
            DialogItemContent(
              DialogItemType.item,
              title: "Редактировать адрес",
              icon: IconAsset.edit,
            ),
            DialogItemContent(
              DialogItemType.item,
              title: "Дублировать адрес",
              icon: IconAsset.duplicate,
            ),
            DialogItemContent(
              DialogItemType.item,
              title: "Удалить адрес",
              icon: IconAsset.delete,
              color: Colors.red,
            ),
            DialogItemContent(
              DialogItemType.system,
              title: "Отменить",
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => widget.onSelect?.call(widget.userAddress),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: RefashionedRadioButtonStateless(
                  value: widget.value,
                ),
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
                          addressesName().toUpperCase(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          widget.userAddress.address?.originalAddress ?? "Нет адреса",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          widget.userAddress.fio + ", " + widget.userAddress.phone,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: dialog,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SVGIcon(
                    icon: IconAsset.more,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
