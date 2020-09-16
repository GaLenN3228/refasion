import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/repositories/user_addresses.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/delivery/components/user_address_list.dart';
import 'package:refashioned_app/screens/marketplace/components/border_button.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class AddressesPage extends StatefulWidget {
  final DeliveryType deliveryType;

  final Function() onClose;
  final Function(String) onFinish;
  final Function() onAddAddress;

  const AddressesPage({
    this.onAddAddress,
    this.onClose,
    this.onFinish,
    this.deliveryType,
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
        bottomText =
            "Чтобы выбрать доставку по адресу измените способ получения в корзине";
        break;

      case Delivery.COURIER_DELIVERY:
      case Delivery.EXPRESS_DEVILERY:
        emptyStateTitle = "Cписок адресов пуст";
        callToAction = "Выберите удобный адрес получения заказа";
        bottomText =
            "Чтобы выбрать доставку в пункт выдачи измените способ получения в корзине";
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
    return ChangeNotifierProvider<GetUserAddressesRepository>(
      create: (_) => GetUserAddressesRepository()..update(),
      child: CupertinoPageScaffold(
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
              child: Consumer<GetUserAddressesRepository>(
                builder: (context, repository, emptyScreen) {
                  List userAddresses;

                  switch (widget.deliveryType.type) {
                    case Delivery.PICKUP_ADDRESS:
                      break;
                    case Delivery.PICKUP_POINT:
                      userAddresses = repository?.response?.content
                          ?.where(
                              (userAddress) => userAddress.pickpoint != null)
                          ?.toList();
                      break;
                    case Delivery.COURIER_DELIVERY:
                    case Delivery.EXPRESS_DEVILERY:
                      userAddresses = repository?.response?.content
                          ?.where(
                              (userAddress) => userAddress.pickpoint == null)
                          ?.toList();
                      break;
                  }

                  if (userAddresses == null || userAddresses.isEmpty)
                    return emptyScreen;

                  return UserAddressesList(
                    list: userAddresses,
                    deliveryType: widget.deliveryType,
                    onAddAddress: widget.onAddAddress,
                    onSelectAddress: (id) => widget.onFinish?.call(id),
                    emptyStateTitle: emptyStateTitle,
                    callToAction: callToAction,
                    bottomText: bottomText,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: BorderButton(
                        type: BorderButtonType.newAddress,
                        onTap: widget.onAddAddress,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
