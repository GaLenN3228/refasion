import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { loading, error, loaded }

class BaseRepository<T> with ChangeNotifier {
  final BuildContext context;
  BaseResponse<T> response;

  Status _status;

  BaseRepository([this.context]);

  Future<void> apiCall(Future<void> Function() execute) async {
    startLoading();
    try {
      await execute();
      checkStatusCode();
      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }

  Future<void> localCall(Future<void> Function() execute) async {
    startLoading();
    try {
      await execute();
      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }

  bool get isLoading => _status == Status.loading;

  bool get loadingFailed => _status == Status.error;

  bool get isLoaded => _status == Status.loaded;

  void startLoading() {
    _status = Status.loading;
  }

  void finishLoading() {
    _status = Status.loaded;
    notifyListeners();
  }

  void receivedError() {
    _status = Status.error;
    notifyListeners();
  }

  void checkStatusCode() {
    if (response == null) {
      throw Exception("response == null, not processed");
    }

    switch (response.status.code) {
      case HttpStatus.ok:
        break;

      case HttpStatus.created:
        break;

      case HttpStatus.accepted:
        break;

      case HttpStatus.unauthorized:
        setAuthorized(false);
        throw Exception("unauthorized, status code: ${response.getStatusCode.toString()}");
        break;

      default:
        throw Exception("response exception, status code: "
            "${response.getStatusCode.toString()}, "
            "error: ${response.errors != null ? response.errors.getErrors : "null"}");
        break;
    }
  }

  int get getStatusCode {
    if (response != null) {
      return response.getStatusCode;
    } else
      throw Exception("response == null, not processed");
  }

  static Future<void> setAuthorized(bool isAuthorized) async =>
      SharedPreferences.getInstance().then((prefs) => prefs.setBool(Prefs.is_authorized, isAuthorized));

  static Future<bool> isAuthorized() async =>
      SharedPreferences.getInstance().then((prefs) => prefs.getBool(Prefs.is_authorized) ?? false );
}
