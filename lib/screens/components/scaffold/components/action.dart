import 'package:flutter/material.dart';

enum ScrollActionType { elevateTopBar, fadeTopBarMiddle }
enum ScrollActionState { none, forwarded, reversed }

class ScaffoldScrollAction {
  ScaffoldScrollAction({this.type}) : assert(type != null);

  final ScrollActionType type;
  final state = ValueNotifier<ScrollActionState>(ScrollActionState.none);

  double _actionOffset = 0;
  AnimationController animationController;

  bool update(double offset) {
    switch (state.value) {
      case ScrollActionState.none:
      case ScrollActionState.reversed:
        if (offset > _actionOffset) {
          state.value = ScrollActionState.forwarded;
          animationController?.forward();
          return true;
        }
        break;
      case ScrollActionState.forwarded:
        if (offset < _actionOffset) {
          state.value = ScrollActionState.reversed;
          animationController?.reverse();
          return true;
        }
        break;
    }

    return false;
  }

  bool compareTo(ScaffoldScrollAction other) =>
      this.type != other.type || this._actionOffset != other._actionOffset;

  setAction(double offset, AnimationController newAnimationController) {
    animationController?.dispose();

    _actionOffset = offset;
    animationController = newAnimationController;
  }

  @override
  String toString() =>
      "Scroll action: " +
      type.toString() +
      ", action offset - " +
      _actionOffset.toString() +
      ", animation controller - " +
      animationController.toString();

  dispose() {
    state.dispose();
    animationController?.dispose();
  }
}
