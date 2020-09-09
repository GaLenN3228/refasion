import 'package:flutter/cupertino.dart';

class TopPanelController with ChangeNotifier {
  bool _needShowBack = false;
  bool _needShow = true;

  bool get needShowBack => _needShowBack;

  set needShowBack(bool value) {
    _needShowBack = value;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  bool get needShow => _needShow;

  set needShow(bool value) {
    _needShow = value;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }
}
