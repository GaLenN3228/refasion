import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/marketplace/components/border_button.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class AddressesPage extends StatefulWidget {
  final DeliveryType deliveryOption;
  final Address initialData;

  final Function() onClose;
  final Function(Address) onUpdate;
  final Function() onPush;
  final Function() onSkip;

  const AddressesPage(
      {this.onPush,
      this.onClose,
      this.onSkip,
      this.initialData,
      this.onUpdate,
      this.deliveryOption});

  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  String callToAction;
  String emptyStateTitle;

  @override
  void initState() {
    switch (widget.deliveryOption) {
      case DeliveryType.PICKUP_POINT:
        emptyStateTitle = "Нет ПВЗ";
        callToAction = "Выберите удобный пункт выдачи заказов";
        break;

      case DeliveryType.COURIER_DELIVERY:
      case DeliveryType.EXPRESS_DEVILERY:
        emptyStateTitle = "Cписок адресов пуст";
        callToAction = "Выберите удобный адрес получения заказа";
        break;

      default:
        emptyStateTitle = "Самовывоз?";
        callToAction = "Его тут быть не должно";
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: widget.onSkip,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SVGIcon(
                            icon: IconAsset.location,
                            size: 48,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              emptyStateTitle,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            width: 230,
                            child: Text(
                              callToAction,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: BorderButton(
                    type: BorderButtonType.newAddress,
                    onTap: widget.onPush,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
