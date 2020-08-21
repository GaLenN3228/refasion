import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Status { loading, error, loaded }

abstract class BaseRepository with ChangeNotifier {
  final BuildContext context;

  ValueNotifier<Status> _statusNotifier;

  Status _status;

  BaseRepository([this.context]) {
    _statusNotifier = ValueNotifier(Status.loading);

    startLoading();
    loadData();
  }

  Future<void> loadData();

  Future<void> refreshData() => loadData();

  bool get isLoading => _status == Status.loading;
  bool get loadingFailed => _status == Status.error;
  bool get isLoaded => _status == Status.loaded;

  ValueNotifier<Status> get statusNotifier => _statusNotifier;

  void startLoading() {
    _status = Status.loading;

    _statusNotifier.value = _status;
  }

  void finishLoading() {
    _status = Status.loaded;

    _statusNotifier.value = _status;

    notifyListeners();
  }

  void receivedError() {
    _status = Status.error;

    _statusNotifier.value = _status;

    notifyListeners();
  }
}
