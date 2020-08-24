import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';

class ScaffoldScrollActionsProvider {
  final actions = List<ScaffoldScrollAction>();

  final activeActions = ValueNotifier<List<ScaffoldScrollAction>>([]);

  ScaffoldScrollActionsProvider({bool shouldElevateOnScroll: true}) {
    if (shouldElevateOnScroll)
      actions.add(ScaffoldScrollAction(type: ScrollActionType.elevateTopBar));
  }

  setAction(ScrollActionType type, double offset,
      AnimationController animationController) {
    final action =
        actions.firstWhere((action) => action.type == type, orElse: () => null);

    if (action != null)
      action.setAction(offset, animationController);
    else
      actions.add(ScaffoldScrollAction(type: type)
        ..setAction(offset, animationController));
  }

  update(double offset) => activeActions.value = actions
      .where(
        (action) => action.update(offset),
      )
      .toList();

  ScaffoldScrollAction getAction(ScrollActionType type) =>
      actions.firstWhere((action) => action.type == type, orElse: () => null);

  dispose() {
    activeActions.dispose();
    actions.forEach((action) => action.dispose());
  }
}
