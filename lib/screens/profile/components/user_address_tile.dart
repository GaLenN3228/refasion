import 'package:flutter/material.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog_item.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog.dart' as CustomDialog;

enum UserAddressesListType { pickup, delivery, pickpoint }

class UserAddressTile extends StatefulWidget {
  final UserAddress userAddress;
  final UserAddressesListType type;

  const UserAddressTile({
    Key key,
    this.userAddress,
    this.type,
  }) : super(key: key);

  @override
  _UserAddressTileState createState() => _UserAddressTileState();
}

class _UserAddressTileState extends State<UserAddressTile> {
  String addressesName() {
    switch (widget.type) {
      case UserAddressesListType.pickup:
        return "Самовывоз по адресу";

      case UserAddressesListType.pickpoint:
        switch (widget.userAddress.type) {
          case UserAddressType.pickpoint:
            return "Пункт выдачи";

          case UserAddressType.boxberry_pickpoint:
            return "Пункт выдачи Boxrberry";

          default:
            return "Что-то не так";
        }
        break;

      case UserAddressesListType.delivery:
        return "Доставка по адресу";

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
              onClick: () {
                Navigator.of(dialogContext).pop();
              },
              icon: IconAsset.edit,
            ),
            DialogItemContent(
              DialogItemType.item,
              title: "Дублировать адрес",
              onClick: () {
                Navigator.of(dialogContext).pop();
              },
              icon: IconAsset.duplicate,
            ),
            DialogItemContent(
              DialogItemType.item,
              title: "Удалить адрес",
              onClick: () {
                Navigator.of(dialogContext).pop();
              },
              icon: IconAsset.delete,
              color: Colors.red,
            ),
            DialogItemContent(
              DialogItemType.system,
              title: "Отменить",
              onClick: () => Navigator.of(dialogContext).pop(),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: dialog,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SVGIcon(
                  icon: IconAsset.more,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      );
}
