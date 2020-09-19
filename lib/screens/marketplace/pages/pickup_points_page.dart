import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/maps/controllers/map_bottom_sheet_data_controller.dart';
import 'package:refashioned_app/screens/maps/controllers/map_data_controller.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';

class PickUpPointsPage extends StatefulWidget {
  final PickPoint address;

  const PickUpPointsPage({Key key, this.address}) : super(key: key);

  @override
  _PickUpPointsPageState createState() => _PickUpPointsPageState();
}

class _PickUpPointsPageState extends State<PickUpPointsPage> {
  MapDataController mapDataController;
  MapBottomSheetDataController mapBottomSheetDataController;

  @override
  void initState() {
    mapDataController =
        MapDataController(pickUpPointsCompany: PickUpPointsCompany.BOXBERRY);
    mapBottomSheetDataController = MapBottomSheetDataController(
        mapBottomSheetDataPreview: MapBottomSheetData(
            title: "Пункты отправки",
            hint:
                "Продавцу нужно отнести вещь в пункт отправки службы доставки, которую выберет покупатель."),
        mapBottomSheetDataAddress: MapBottomSheetData(
          isCancelPointEnable: true,
          title: "Адрес доставки",
        ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData(
              leftButtonData: TBButtonData.icon(
                TBIconType.back,
                onTap: () => Navigator.of(context).pop(),
              ),
              middleData: TBMiddleData.title("Пункты отправлений"),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: MapsPickerPage(
              mapDataController: mapDataController,
              mapBottomSheetDataController: mapBottomSheetDataController,
            ),
          ),
        ],
      ),
    );
  }
}
