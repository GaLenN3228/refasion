import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';

class MapDataController with ChangeNotifier {
  PickPoint _pickPoint;
  final PickUpPointsCompany _pickUpPointsCompany;
  final bool _centerMarkerEnable;
  final Function() _onSearchButtonClick;

  MapDataController(
      {PickPoint pickPoint, PickUpPointsCompany pickUpPointsCompany, bool centerMarkerEnable, Function() onSearchButtonClick})
      : _pickPoint = pickPoint,
        _pickUpPointsCompany = pickUpPointsCompany,
        _centerMarkerEnable = centerMarkerEnable ?? false,
        _onSearchButtonClick = onSearchButtonClick;

  Function get onSearchButtonClick => _onSearchButtonClick;

  bool get centerMarkerEnable => _centerMarkerEnable;

  PickUpPointsCompany get pickUpPointsCompany => _pickUpPointsCompany;

  PickPoint get pickPoint => _pickPoint;

  set pickPoint(PickPoint value) {
    _pickPoint = value;
  }
}
