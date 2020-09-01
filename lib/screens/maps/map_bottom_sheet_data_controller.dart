import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/models/pick_point.dart';

enum MapBottomSheetDataType { PREVIEW, ADDRESS, NOT_FOUND }

class MapBottomSheetDataController with ChangeNotifier {
  final MapBottomSheetData _mapBottomSheetDataPreview;
  final MapBottomSheetData _mapBottomSheetDataAddress;
  final MapBottomSheetData _mapBottomSheetDataNotFound;
  MapBottomSheetData _currentBottomSheetData;

  MapBottomSheetDataController(
      {MapBottomSheetData mapBottomSheetDataPreview,
      MapBottomSheetData mapBottomSheetDataAddress,
      MapBottomSheetData mapBottomSheetDataNotFound})
      : _mapBottomSheetDataPreview = mapBottomSheetDataPreview,
        _mapBottomSheetDataAddress = mapBottomSheetDataAddress,
        _mapBottomSheetDataNotFound = mapBottomSheetDataNotFound;

  MapBottomSheetData get currentBottomSheetData => _currentBottomSheetData;

  set setCurrentBottomSheetData(MapBottomSheetDataType mapBottomSheetDataType) {
    switch (mapBottomSheetDataType) {
      case MapBottomSheetDataType.PREVIEW:
        _currentBottomSheetData = _mapBottomSheetDataPreview;
        break;
      case MapBottomSheetDataType.ADDRESS:
        _currentBottomSheetData = _mapBottomSheetDataAddress;
        break;
      case MapBottomSheetDataType.NOT_FOUND:
        _currentBottomSheetData = _mapBottomSheetDataNotFound;
        break;
    }
    notifyListeners();
  }
}

class MapBottomSheetData extends ChangeNotifier {
  String _title;
  String _type;
  String _address;
  String _addressTitle;
  String _workSchedule;
  String _workScheduleTitle;
  String _info;
  String _hint;
  String _finishButtonText;
  bool _isFinishButtonEnable;
  final Function(PickPoint) _onFinishButtonClick;

  MapBottomSheetData(
      {String title,
      String type,
      String address,
      String addressTitle,
      String workSchedule,
      String workScheduleTitle,
      String info,
      String hint,
      String finishButtonText,
      bool isFinishButtonEnable,
      Function(PickPoint) onFinishButtonClick})
      : _title = title,
        _address = address,
        _addressTitle = addressTitle,
        _workSchedule = workSchedule,
        _workScheduleTitle = workScheduleTitle,
        _info = info,
        _hint = hint,
        _finishButtonText = finishButtonText,
        _isFinishButtonEnable = isFinishButtonEnable ?? false,
        _onFinishButtonClick = onFinishButtonClick;

  String get title => _title;

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String get type => _type;

  set type(String value) {
    _type = value;
    notifyListeners();
  }

  String get address => _address;

  set address(String value) {
    _address = value;
    notifyListeners();
  }

  String get addressTitle => _addressTitle;

  set addressTitle(String value) {
    _addressTitle = value;
    notifyListeners();
  }

  String get workSchedule => _workSchedule;

  set workSchedule(String value) {
    _workSchedule = value;
    notifyListeners();
  }

  String get workScheduleTitle => _workScheduleTitle;

  set workScheduleTitle(String value) {
    _workScheduleTitle = value;
    notifyListeners();
  }

  Function get onFinishButtonClick => _onFinishButtonClick;

  String get finishButtonText => _finishButtonText;

  set finishButtonText(String value) {
    _finishButtonText = value;
    notifyListeners();
  }

  String get hint => _hint;

  set hint(String value) {
    _hint = value;
    notifyListeners();
  }

  String get info => _info;

  set info(String value) {
    _info = value;
    notifyListeners();
  }

  bool get isFinishButtonEnable => _isFinishButtonEnable;

  set isFinishButtonEnable(bool value) {
    _isFinishButtonEnable = value;
  }
}
