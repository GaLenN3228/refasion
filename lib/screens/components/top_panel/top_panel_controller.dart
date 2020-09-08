import 'package:flutter/cupertino.dart';

class TopPanelController with ChangeNotifier {
  bool _needShow = false;

  bool get needShow => _needShow;

  set needShow(bool value) {
    _needShow = value;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }
}
