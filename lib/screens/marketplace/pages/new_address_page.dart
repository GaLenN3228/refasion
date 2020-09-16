import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/maps/controllers/map_bottom_sheet_data_controller.dart';
import 'package:refashioned_app/screens/maps/controllers/map_data_controller.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';
import 'package:refashioned_app/screens/marketplace/pages/address_search_page.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class NewAddressPage extends StatelessWidget {
  BuildContext _context;
  final Function(Address) onAddressPush;

  MapDataController mapDataController;
  MapBottomSheetDataController mapBottomSheetDataController;

  NewAddressPage({Key key, this.onAddressPush}) : super(key: key) {
    initMapControllers();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
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
              middleData: TBMiddleData.title("Новый адрес"),
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

  void initMapControllers() {
    mapDataController = MapDataController(
        centerMarkerEnable: true,
        onSearchButtonClick: () {
          showBottomSheet();
        });
    mapBottomSheetDataController = MapBottomSheetDataController(
        mapBottomSheetDataPreview:
            MapBottomSheetData(title: "Где хранится вещь?", hint: "Укажите на карте или введите адрес вручную"),
        mapBottomSheetDataAddress: MapBottomSheetData(
            title: "Где хранится вещь?",
            finishButtonText: "ПРОДОЛЖИТЬ",
            isFinishButtonEnable: true,
            onFinishButtonClick: (pickPoint) {
              onAddressPush(Address(
                  coordinates: Point(latitude: pickPoint.latitude, longitude: pickPoint.longitude),
                  address: pickPoint.address,
                  originalAddress: pickPoint.originalAddress,
                  city: pickPoint.city));
            }),
        mapBottomSheetDataNotFound: MapBottomSheetData(
            title: "Где хранится вещь?",
            finishButtonText: "ПРОДОЛЖИТЬ",
            isFinishButtonEnable: false,
            address: "Не удалось определить точный адрес"));
  }

  void showBottomSheet() {
    if (_context != null)
      showCupertinoModalBottomSheet(
          expand: true,
          context: _context,
          builder: (context, controller) => AddressSearchPage(
              scrollController: controller,
              onSelect: (address) {
                mapDataController.pickPoint = PickPoint(
                    address: address.address,
                    originalAddress: address.originalAddress,
                    latitude: address.coordinates.latitude,
                    longitude: address.coordinates.longitude,
                    city: address.city);
              }));
  }
}
