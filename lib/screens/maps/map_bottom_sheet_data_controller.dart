import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/models/pick_point.dart';

class MapBottomSheetDataController with ChangeNotifier {
  String _title;
  String _type;
  String _address;
  String _addressTitle;
  String _workSchedule;
  String _workScheduleTitle;
  String _info;
  String _hint;
  String _finishButtonText;
  bool _isFinishButtonEnable = true;
  final Function(PickPoint) _onFinishButtonClick;

  MapBottomSheetDataController(
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
        _isFinishButtonEnable = isFinishButtonEnable,
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
