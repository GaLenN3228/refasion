import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/maps/controllers/map_bottom_sheet_data_controller.dart';
import 'package:refashioned_app/screens/maps/controllers/map_data_controller.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';
import 'package:refashioned_app/screens/marketplace/pages/address_search_page.dart';

class NewAddressPage extends StatefulWidget {
  final Function(PickPoint) onSelect;
  final Function() onClose;

  const NewAddressPage({Key key, this.onSelect, this.onClose}) : super(key: key);

  @override
  _NewAddressPageState createState() => _NewAddressPageState();
}

class _NewAddressPageState extends State<NewAddressPage> {
  MapDataController mapDataController;

  MapBottomSheetDataController mapBottomSheetDataController;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.simple(
              onBack: Navigator.of(context).pop,
              middleText: "Новый адрес",
              onClose: widget.onClose,
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

  @override
  initState() {
    mapDataController = MapDataController(
      centerMarkerEnable: true,
      onSearchButtonClick: () {
        showBottomSheet();
      },
    );

    mapBottomSheetDataController = MapBottomSheetDataController(
      mapBottomSheetDataPreview: MapBottomSheetData(
        title: "Где хранится вещь?",
        hint: "Укажите на карте или введите адрес вручную",
      ),
      mapBottomSheetDataAddress: MapBottomSheetData(
        title: "Где хранится вещь?",
        finishButtonText: "ПРОДОЛЖИТЬ",
        isFinishButtonEnable: true,
        onFinishButtonClick: (widget.onSelect),
      ),
      mapBottomSheetDataNotFound: MapBottomSheetData(
        title: "Где хранится вещь?",
        finishButtonText: "ПРОДОЛЖИТЬ",
        isFinishButtonEnable: false,
        address: "Не удалось определить точный адрес",
      ),
    );

    super.initState();
  }

  showBottomSheet() => showCupertinoModalBottomSheet(
        expand: true,
        context: context,
        builder: (context, controller) => AddressSearchPage(
            scrollController: controller, onSelect: (address) => mapDataController.pickPoint = address),
      );
}
