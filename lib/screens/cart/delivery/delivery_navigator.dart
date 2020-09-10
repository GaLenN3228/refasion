import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/cart/delivery/pages/addresses_page.dart';
import 'package:refashioned_app/screens/cart/delivery/pages/map_page.dart';
import 'package:refashioned_app/screens/cart/delivery/pages/recipient_info_page.dart';

class DeliveryNavigatorRoutes {
  static const String addresses = '/';
  static const String map = '/map';
  static const String recipientInfo = '/recipientInfo';
}

class DeliveryNavigator extends StatefulWidget {
  final Function() onClose;
  final Function() onAcceptPickUpAddress;
  final DeliveryType deliveryType;
  final PickPoint pickUpAddress;

  const DeliveryNavigator({
    Key key,
    this.onClose,
    this.deliveryType,
    this.pickUpAddress,
    this.onAcceptPickUpAddress,
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
          deliveryOption: widget.deliveryType,
          onClose: widget.onClose,
          onPush: () {
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
          deliveryOption: widget.deliveryType,
          onClose: widget.onClose,
          onAcceptPickUpAddress: widget.onClose,
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
          address: address,
          deliveryType: widget.deliveryType,
          onClose: widget.onClose,
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
    print("delivery type: " + widget.deliveryType.toString());

    if (widget.deliveryType == DeliveryType.PICKUP_ADDRESS)
      return MapPage(
        deliveryOption: widget.deliveryType,
        onClose: widget.onClose,
        pickUpAddress: widget.pickUpAddress,
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
