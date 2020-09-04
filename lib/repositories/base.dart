import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { LOADING, ERROR, LOADED }

class BaseRepository<T> with ChangeNotifier {
  final BuildContext context;
  BaseResponse<T> response;

  ValueNotifier<Status> _statusNotifier;

  Status _status;

  BaseRepository([this.context]) {
    _statusNotifier = ValueNotifier(Status.LOADING);
  }

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

  bool get isLoading => _status == Status.LOADING;

  bool get loadingFailed => _status == Status.ERROR;

  bool get isLoaded => _status == Status.LOADED;

  ValueNotifier<Status> get statusNotifier => _statusNotifier;

  void startLoading() {
    _status = Status.LOADING;

    _statusNotifier.value = _status;

    notifyListeners();
  }

  void finishLoading() {
    _status = Status.LOADED;

    _statusNotifier.value = _status;

    notifyListeners();
  }

  void receivedError() {
    _status = Status.ERROR;

    _statusNotifier.value = _status;

    notifyListeners();
  }

  void abortLoading({String message}) {
    throw Exception(message ?? "loading aborted");
  }

  void checkStatusCode() {
    if (response == null) {
      abortLoading(message: "response == null, not processed");
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
        abortLoading(message: "unauthorized, status code: ${response.getStatusCode.toString()}");
        break;

      default:
        abortLoading(
            message: "response exception, status code: "
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
      SharedPreferences.getInstance().then((prefs) => prefs.getBool(Prefs.is_authorized) ?? false);
}
