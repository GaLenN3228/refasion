import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/repositories/pick_point.dart';
import 'package:refashioned_app/screens/maps/components/buttons/compass_button.dart';
import 'package:refashioned_app/screens/maps/components/buttons/geolocation_button.dart';
import 'package:refashioned_app/screens/maps/components/buttons/search_button.dart';
import 'package:refashioned_app/screens/maps/components/map.dart';
import 'package:refashioned_app/screens/maps/components/sheet_data/pickup_point_address.dart';

class MapsPickerPage extends StatelessWidget {
  final Function(Address) onAddressPush;
  final Function({Function(Address) callback}) onSearchTap;

  MapsPickerPage({Key key, this.onAddressPush, this.onSearchTap})
      : super(key: key);

  onSearchSelect(Address newAddress) => print(newAddress.toString());

  @override
  Widget build(BuildContext context) {
    final mapsPage = MapPage(
      onPointClick: (point) {
        showBottomSheet(context, point);
      },
    );
    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: Expanded(
          child: Stack(
            children: [
              Container(
                  child: ChangeNotifierProvider<PickPointRepository>(
                create: (_) => PickPointRepository(),
                child: mapsPage,
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CompassButton(
                      show: ValueNotifier(true),
                    ),
                    SearchButton(
                      onTap: () => onSearchTap(callback: onSearchSelect),
                    ),
                    GeolocationButton(
                      onTap: mapsPage.showUserLocation,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void showBottomSheet(BuildContext context, PickPoint point) {
    showCupertinoModalBottomSheet(
        barrierColor: Colors.black.withAlpha(1),
        expand: false,
        elevation: 4,
        isDismissible: true,
        context: context,
        builder: (context, controller) => PickupPointAddress(point: point));
  }
}
