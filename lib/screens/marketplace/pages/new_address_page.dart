import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/maps/map_bottom_sheet_data_controller.dart';
import 'package:refashioned_app/screens/maps/map_data_controller.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';

class NewAddressPage extends StatelessWidget {
  final Function(Address) onPush;

  const NewAddressPage({Key key, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    var mapController = MapDataController(centerMarkerEnable: false, onSearchButtonClick: () {}, pickUpPointsCompany: PickUpPointsCompany.BOXBERRY);
    var mapBottomSheetController = MapBottomSheetDataController(
        title: "Где хранится вещь?",
        onFinishButtonClick: (point) {
          print("${point.address} | ${point.workSchedule}");
        });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            RefashionedTopBar(
              data: TopBarData(
                leftButtonData: TBButtonData.icon(
                  TBIconType.back,
                  onTap: () => Navigator.of(context).pop(),
                ),
                middleData: TBMiddleData.title("Новый адрес"),
                rightButtonData: TBButtonData(iconType: TBIconType.filters),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
                child: MapsPickerPage(
              mapDataController: mapController,
              mapBottomSheetDataController: mapBottomSheetController,
            ))
          ],
        ),
      ),
    );
  }
}
