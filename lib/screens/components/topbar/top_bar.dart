import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_content.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';

class RefashionedTopBar extends StatefulWidget {
  final TopBarData data;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  const RefashionedTopBar({Key key, this.data, this.scrollActionsProvider})
      : super(key: key);

  @override
  _RefashionedTopBarState createState() => _RefashionedTopBarState();
}

class _RefashionedTopBarState extends State<RefashionedTopBar>
    with TickerProviderStateMixin {
  final flatShadow = null;
  final elevatedShadow = BoxShadow(
      color: Colors.black.withOpacity(0.05),
      offset: Offset(0, 4),
      blurRadius: 4);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animationController = widget.scrollActionsProvider
        ?.getAction(ScrollActionType.elevateTopBar)
        ?.animationController;

    if (animationController == null)
      return Container(
        color: widget.data.backgroundColor ?? Colors.red,
        child: TBContent(
          data: widget.data,
          scrollActionsProvider: widget.scrollActionsProvider,
        ),
      );

    final animation =
        Tween<double>(begin: 0, end: 1).animate(animationController);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Container(
        child: child,
        decoration: BoxDecoration(
          color: widget.data.backgroundColor ?? Colors.amber,
          boxShadow: [
            BoxShadow.lerp(flatShadow, elevatedShadow, animation.value)
          ],
        ),
      ),
      child: TBContent(
        data: widget.data,
        scrollActionsProvider: widget.scrollActionsProvider,
      ),
    );
  }
}
