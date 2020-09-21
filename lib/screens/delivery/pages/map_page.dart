import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/maps/controllers/map_bottom_sheet_data_controller.dart';
import 'package:refashioned_app/screens/maps/controllers/map_data_controller.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';
import 'package:refashioned_app/screens/marketplace/pages/address_search_page.dart';

class MapPage extends StatefulWidget {
  final DeliveryType deliveryType;

  final Function(PickPoint) onAddressPush;
  final Function() onClose;
  final Function(String) onFinish;

  const MapPage({
    Key key,
    this.onAddressPush,
    this.onClose,
    this.deliveryType,
    this.onFinish,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapDataController mapDataController;
  MapBottomSheetDataController mapBottomSheetDataController;

  TopBarData topBarData;

  @override
  initState() {
    switch (widget.deliveryType.type) {
      case Delivery.PICKUP_ADDRESS:
        mapDataController = MapDataController(
          pickPoint: widget.deliveryType.deliveryOptions.first.deliveryObject ??
              PickPoint(
                address: "пр-д Серебрякова, 4, строение 1, Москва, 129343",
                originalAddress: "пр-д Серебрякова, 4, строение 1, Москва, 129343",
                latitude: 55.846726,
                longitude: 37.647794,
              ),
        );

        mapBottomSheetDataController = MapBottomSheetDataController(
          mapBottomSheetDataAddress: MapBottomSheetData(
            title: "Адрес самовывоза",
            finishButtonText: "Заберу отсюда".toUpperCase(),
            isFinishButtonEnable: true,
            onFinishButtonClick: (_) => widget.onFinish?.call(null),
          ),
        );

        topBarData = TopBarData.simple(
          middleText: "Адрес самовывоза",
          onClose: widget.onClose,
        );
        break;
      case Delivery.PICKUP_POINT:
        mapDataController = MapDataController(pickUpPointsCompany: PickUpPointsCompany.BOXBERRY);

        mapBottomSheetDataController = MapBottomSheetDataController(
          mapBottomSheetDataPreview: MapBottomSheetData(
            title: "Куда доставить заказ?",
            hint: "Выберите пункт выдачи на карте",
          ),
          mapBottomSheetDataAddress: MapBottomSheetData(
            title: "Адрес доставки",
            finishButtonText: "Привезти сюда".toUpperCase(),
            isFinishButtonEnable: true,
            onFinishButtonClick: widget.onAddressPush,
          ),
        );

        topBarData = TopBarData.simple(
          middleText: "Новый адрес",
          onBack: Navigator.of(context).canPop() ? Navigator.of(context).pop : null,
          onClose: widget.onClose,
        );
        break;
      case Delivery.COURIER_DELIVERY:
      case Delivery.EXPRESS_DEVILERY:
        mapDataController =
            MapDataController(centerMarkerEnable: true, onSearchButtonClick: showBottomSheet);

        mapBottomSheetDataController = MapBottomSheetDataController(
          mapBottomSheetDataPreview: MapBottomSheetData(
            title: "Куда доставить заказ?",
            hint: "Укажите на карте или введите адрес вручную",
          ),
          mapBottomSheetDataAddress: MapBottomSheetData(
            title: "Адрес доставки",
            finishButtonText: "Привезти сюда".toUpperCase(),
            isFinishButtonEnable: true,
            onFinishButtonClick: widget.onAddressPush,
          ),
          mapBottomSheetDataNotFound: MapBottomSheetData(
              title: "Адрес доставки",
              finishButtonText: "ПРИВЕЗТИ СЮДА",
              isFinishButtonEnable: false,
              address: "Не удалось определить точный адрес"),
        );

        topBarData = TopBarData.simple(
          middleText: "Новый адрес",
          onBack: Navigator.of(context).canPop() ? Navigator.of(context).pop : null,
          onClose: widget.onClose,
        );
        break;
    }

    super.initState();
  }

  showBottomSheet() {
    HapticFeedback.lightImpact();

    showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      builder: (context, controller) => AddressSearchPage(
        scrollController: controller,
        onSelect: (address) => mapDataController.pickPoint = address,
      ),
    );
  }

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
