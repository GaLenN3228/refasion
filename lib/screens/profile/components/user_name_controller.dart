import 'package:flutter/cupertino.dart';

class UserNameController with ChangeNotifier {
  void update() {
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }
}
