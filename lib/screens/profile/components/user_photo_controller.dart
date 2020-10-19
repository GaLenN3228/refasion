import 'package:flutter/cupertino.dart';

class UserPhotoController with ChangeNotifier {
  void update() {
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }
}
