import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';

enum RBState { enabled, loading, done, error, disabled }

class RBData extends ChangeNotifier {
  RBState _state;
  RBState get state => _state;

  Map<RBState, RBStateData> _data;
  Map<RBState, RBStateData> get data => _data;

  RBStateData _stateData;
  RBStateData get stateData => _stateData;

  double _height;
  double get height => _height;

  bool _animatePress = true;
  bool get animatePress => _animatePress;

  int _duration = 300;
  int get duration => _duration;

  ValueNotifier<bool> available = ValueNotifier(true);

  setState(
    RBState newState, {
    bool animateTitleIn: true,
    bool animateTitleOut: true,
    bool animateCaptionIn: true,
    bool animateCaptionOut: true,
    bool animateIconIn: true,
    bool animateIconOut: true,
  }) async {
    if (_state != newState) {
      if (_data.containsKey(newState)) {
        if (available.value)
          available.value = false;
        else
          await Future.delayed(Duration(milliseconds: duration));

        _state = newState;
        _stateData = _data[_state]
          ..animateTitleIn = animateTitleIn
          ..animateTitleOut = animateTitleOut
          ..animateCaptionIn = animateCaptionIn
          ..animateCaptionOut = animateCaptionOut
          ..animateIconIn = animateIconIn
          ..animateIconOut = animateIconOut;

        notifyListeners();

        available.value = true;
      }
    }
  }

  setStateData(RBStateData newData) {
    if (_stateData != newData) {
      _stateData = newData;

      notifyListeners();
    }
  }

  updateStateData(RBState newState, RBStateData newData, {bool notify: true}) {
    if (_data.containsKey(newState)) {
      _data[newState] = newData;

      if (notify) notifyListeners();
    }
  }

  RBData._(
    this._stateData,
    this._state,
    this._data,
    this._height,
    this._animatePress,
  );

  factory RBData.map({
    RBState initState,
    Map<RBState, RBStateData> data,
    double height: 45,
    bool animatePress: true,
  }) {
    if (initState == null || data == null || !data.containsKey(initState) || height == null) return null;

    return RBData._(
      data[initState],
      initState,
      data,
      height,
      animatePress,
    );
  }

  factory RBData.single({
    RBStateData data,
    double height: 45,
    bool animatePress: true,
  }) {
    if (data == null || height == null) return null;

    return RBData._(
      data,
      null,
      null,
      height,
      animatePress,
    );
  }
}
