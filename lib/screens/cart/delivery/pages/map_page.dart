import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/maps/controllers/map_bottom_sheet_data_controller.dart';
import 'package:refashioned_app/screens/maps/controllers/map_data_controller.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';
import 'package:refashioned_app/screens/marketplace/pages/address_search_page.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapPage extends StatefulWidget {
  final DeliveryType deliveryOption;
  final Address pickUpAddress;

  final Function(Address) onAddressPush;
  final Function() onClose;

  const MapPage(
      {Key key,
      this.onAddressPush,
      this.deliveryOption,
      this.onClose,
      this.pickUpAddress})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapDataController mapDataController;
  MapBottomSheetDataController mapBottomSheetDataController;

  TopBarData topBarData;

  @override
  initState() {
    switch (widget.deliveryOption) {
      case DeliveryType.PICKUP_ADDRESS:
        //TODO: set initial PickPoint to widget.pickUpAddress
        mapDataController =
            MapDataController(centerMarkerEnable: true); //false?
        mapBottomSheetDataController = MapBottomSheetDataController(
          mapBottomSheetDataPreview: MapBottomSheetData(
            title: "Адрес самовывоза",
            hint: "Адрес: " + widget.pickUpAddress?.originalAddress.toString(),
          ),
        );

        topBarData = TopBarData.simple(
          middleText: "Адрес самовывоза",
          onClose: widget.onClose,
        );
        break;
      case DeliveryType.PICKUP_POINT:
        mapDataController = MapDataController(
            pickUpPointsCompany: PickUpPointsCompany.BOXBERRY);
        mapBottomSheetDataController = MapBottomSheetDataController(
          mapBottomSheetDataPreview: MapBottomSheetData(
            title: "Куда доставить заказ?",
            hint: "Выберите пункт выдачи на карте",
          ),
          mapBottomSheetDataAddress: MapBottomSheetData(
            title: "Адрес доставки",
            finishButtonText: "ПРИВЕЗТИ СЮДА",
            isFinishButtonEnable: true,
            onFinishButtonClick: (pickPoint) {
              widget.onAddressPush(
                Address(
                    coordinates: Point(
                        latitude: pickPoint.latitude,
                        longitude: pickPoint.longitude),
                    address: pickPoint.address,
                    originalAddress: pickPoint.originalAddress,
                    city: pickPoint.city),
              );
            },
          ),
        );

        topBarData = TopBarData.simple(
          middleText: "Новый адрес",
          onBack: Navigator.of(context).pop,
          onClose: widget.onClose,
        );
        break;
      case DeliveryType.COURIER_DELIVERY:
      case DeliveryType.EXPRESS_DEVILERY:
        mapDataController = MapDataController(
            centerMarkerEnable: true, onSearchButtonClick: showBottomSheet);
        mapBottomSheetDataController = MapBottomSheetDataController(
          mapBottomSheetDataPreview: MapBottomSheetData(
            title: "Куда доставить заказ?",
            hint: "Укажите на карте или введите адрес вручную",
          ),
          mapBottomSheetDataAddress: MapBottomSheetData(
            title: "Адрес доставки",
            finishButtonText: "ПРИВЕЗТИ СЮДА",
            isFinishButtonEnable: true,
            onFinishButtonClick: (pickPoint) {
              widget.onAddressPush(
                Address(
                    coordinates: Point(
                        latitude: pickPoint.latitude,
                        longitude: pickPoint.longitude),
                    address: pickPoint.address,
                    originalAddress: pickPoint.originalAddress,
                    city: pickPoint.city),
              );
            },
          ),
          mapBottomSheetDataNotFound: MapBottomSheetData(
              title: "Адрес доставки",
              finishButtonText: "ПРИВЕЗТИ СЮДА",
              isFinishButtonEnable: false,
              address: "Не удалось определить точный адрес"),
        );

        topBarData = TopBarData.simple(
          middleText: "Новый адрес",
          onBack: Navigator.of(context).pop,
          onClose: widget.onClose,
        );
        break;
    }

    super.initState();
  }

  showBottomSheet() => showCupertinoModalBottomSheet(
        expand: true,
        context: context,
        builder: (context, controller) => AddressSearchPage(
          scrollController: controller,
          onSelect: (address) {
            mapDataController.pickPoint = PickPoint(
                address: address.address,
                originalAddress: address.originalAddress,
                latitude: address.coordinates.latitude,
                longitude: address.coordinates.longitude,
                city: address.city);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          RefashionedTopBar(
            data: topBarData,
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
