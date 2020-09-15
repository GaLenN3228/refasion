import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/delivery/pages/addresses_page.dart';
import 'package:refashioned_app/screens/delivery/pages/map_page.dart';
import 'package:refashioned_app/screens/delivery/pages/recipient_info_page.dart';

class DeliveryNavigatorRoutes {
  static const String addresses = '/';
  static const String map = '/map';
  static const String recipientInfo = '/recipientInfo';
}

class DeliveryNavigator extends StatefulWidget {
  final Function() onClose;
  final Function(String) onFinish;

  final DeliveryType deliveryType;
  final PickPoint pickUpAddress;

  const DeliveryNavigator({
    Key key,
    this.onClose,
    this.deliveryType,
    this.onFinish,
    this.pickUpAddress,
  }) : super(key: key);

  @override
  _DeliveryNavigatorState createState() => _DeliveryNavigatorState();
}

class _DeliveryNavigatorState extends State<DeliveryNavigator> {
  Widget _routeBuilder(
    BuildContext context,
    String route, {
    PickPoint address,
  }) {
    switch (route) {
      case DeliveryNavigatorRoutes.addresses:
        return AddressesPage(
          deliveryType: widget.deliveryType,
          onClose: widget.onClose,
          onFinish: widget.onFinish,
          onAddAddress: () {
            Navigator.of(context).push(
              MaterialWithModalsPageRoute(
                builder: (context) => _routeBuilder(
                  context,
                  DeliveryNavigatorRoutes.map,
                ),
                settings: RouteSettings(
                  name: DeliveryNavigatorRoutes.map,
                ),
              ),
            );
          },
        );

      case DeliveryNavigatorRoutes.map:
        return MapPage(
          deliveryType: widget.deliveryType,
          onClose: widget.onClose,
          onFinish: widget.onFinish,
          onAddressPush: (address) {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => _routeBuilder(
                  context,
                  DeliveryNavigatorRoutes.recipientInfo,
                  address: address,
                ),
                settings: RouteSettings(
                  name: DeliveryNavigatorRoutes.recipientInfo,
                ),
              ),
            );
          },
        );

      case DeliveryNavigatorRoutes.recipientInfo:
        return RecipientInfoPage(
          pickpoint: address,
          deliveryType: widget.deliveryType,
          onClose: widget.onClose,
          onFinish: widget.onFinish,
        );

      default:
        return CupertinoPageScaffold(
          backgroundColor: Colors.white,
          child: Center(
            child: Text(
              "Default",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.deliveryType.type == Delivery.PICKUP_ADDRESS)
      return MapPage(
        pickUpAddress: widget.pickUpAddress,
        deliveryType: widget.deliveryType,
        onClose: widget.onClose,
        onFinish: widget.onFinish,
      );

    return Navigator(
      initialRoute: DeliveryNavigatorRoutes.addresses,
      onGenerateRoute: (routeSettings) => CupertinoPageRoute(
        builder: (context) => _routeBuilder(context, routeSettings.name),
        settings: routeSettings,
      ),
    );
  }
}
