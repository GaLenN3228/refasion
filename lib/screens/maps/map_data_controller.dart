import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapDataController with ChangeNotifier {
  Point _point;
  final PickUpPointsCompany _pickUpPointsCompany;
  final bool _centerMarkerEnable;
  final Function() _onSearchButtonClick;

  MapDataController(
      {Point point, PickUpPointsCompany pickUpPointsCompany, bool centerMarkerEnable, Function() onSearchButtonClick})
      : _point = point,
        _pickUpPointsCompany = pickUpPointsCompany,
        _centerMarkerEnable = centerMarkerEnable ?? false,
        _onSearchButtonClick = onSearchButtonClick;

  Function get onSearchButtonClick => _onSearchButtonClick;

  bool get centerMarkerEnable => _centerMarkerEnable;

  PickUpPointsCompany get pickUpPointsCompany => _pickUpPointsCompany;

  Point get point => _point;

  set point(Point value) {
    _point = value;
    notifyListeners();
  }
}
