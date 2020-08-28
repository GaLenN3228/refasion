import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/repositories/pick_point.dart';
import 'package:refashioned_app/screens/maps/components/map.dart';
import 'package:refashioned_app/screens/maps/components/sheet_data/pickup_point_address.dart';

class MapsPickerPage extends StatelessWidget {
  final Function() onPush;

  MapsPickerPage({Key key, this.onPush}) : super(key: key);

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
              Container(
                  padding: EdgeInsets.only(bottom: 28, right: 8),
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => {mapsPage.showUserLocation()},
                    child: SvgPicture.asset(
                      "assets/show_location.svg",
                      width: 70,
                    ),
                  ))
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
