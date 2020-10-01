import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/screens/delivery/pages/addresses_page.dart';
import 'package:refashioned_app/screens/delivery/pages/map_page.dart';
import 'package:refashioned_app/screens/delivery/pages/info_page.dart';

class DeliveryNavigatorRoutes {
  static const String addresses = '/address';
  static const String map = '/map';
  static const String info = '/info';
}

class DeliveryNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    switch (previousRoute?.settings?.name) {
      case DeliveryNavigatorRoutes.addresses:
      case DeliveryNavigatorRoutes.map:
      case DeliveryNavigatorRoutes.info:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;

      default:
        break;
    }

    super.didPop(route, previousRoute);
  }
}

class DeliveryNavigator extends StatefulWidget {
  final Function() onClose;
  final Function(String) onFinish;

  final List<UserAddress> userAddresses;
  final DeliveryType deliveryType;

  const DeliveryNavigator({
    Key key,
    this.onClose,
    this.deliveryType,
    this.onFinish,
    this.userAddresses,
  }) : super(key: key);

  @override
  _DeliveryNavigatorState createState() => _DeliveryNavigatorState();
}

class _DeliveryNavigatorState extends State<DeliveryNavigator> {
  String initialRoute;

  List<UserAddress> userAddresses;
  PickPoint selectedAddress;

  @override
  void initState() {
    switch (widget.deliveryType.type) {
      case Delivery.PICKUP_POINT:
        userAddresses = widget.userAddresses
            ?.where((userAddress) =>
                userAddress != null && userAddress.type == UserAddressType.boxberry_pickpoint ||
                userAddress.type == UserAddressType.pickpoint)
            ?.toList();
        break;

      case Delivery.COURIER_DELIVERY:
      case Delivery.EXPRESS_DEVILERY:
        userAddresses = widget.userAddresses
            ?.where((userAddress) => userAddress != null && userAddress.type == UserAddressType.address)
            ?.toList();
        break;

      default:
        userAddresses = [];
        break;
    }

    initialRoute = widget.deliveryType.type == Delivery.PICKUP_ADDRESS || userAddresses.isEmpty
        ? DeliveryNavigatorRoutes.map
        : DeliveryNavigatorRoutes.addresses;

    super.initState();
  }

  Widget route(BuildContext context, String route) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    switch (route) {
      case DeliveryNavigatorRoutes.addresses:
        return AddressesPage(
          deliveryType: widget.deliveryType,
          onClose: widget.onClose,
          onFinish: widget.onFinish,
          userAddresses: userAddresses,
          onAddAddress: () {
            Navigator.of(context).pushNamed(DeliveryNavigatorRoutes.map);
          },
        );

      case DeliveryNavigatorRoutes.map:
        return MapPage(
          deliveryType: widget.deliveryType,
          onClose: widget.onClose,
          onFinish: widget.onFinish,
          onAddressPush: (newAddress) {
            selectedAddress = newAddress;

            Navigator.of(context).pushNamed(DeliveryNavigatorRoutes.info);
          },
        );

      case DeliveryNavigatorRoutes.info:
        return InfoPage(
          pickpoint: selectedAddress,
          deliveryType: widget.deliveryType,
          onClose: widget.onClose,
          onFinish: widget.onFinish,
        );

      default:
        return CupertinoPageScaffold(
          backgroundColor: Colors.white,
          child: Center(
            child: Text(
              "Маршрут " + route.toString(),
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Navigator(
        initialRoute: initialRoute,
        observers: [
          DeliveryNavigatorObserver(),
        ],
        onGenerateInitialRoutes: (navigator, initialRoute) => [
          CupertinoPageRoute(
            builder: (context) => route(context, initialRoute),
          )
        ],
        onGenerateRoute: (routeSettings) => CupertinoPageRoute(
          builder: (context) => route(context, routeSettings.name),
          settings: routeSettings,
        ),
      );
}
