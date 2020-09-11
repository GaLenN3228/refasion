import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_content.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/utils/colors.dart';

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
  // final flatShadow = null;
  // final elevatedShadow = BoxShadow(
  //     color: Colors.black.withOpacity(0.05),
  //     offset: Offset(0, 4),
  //     blurRadius: 4);

  Color backgroundColor;
  Color statusBarColor;
  Brightness statusBarBrightness;

  @override
  initState() {
    updateByTheme();

    super.initState();
  }

  updateByTheme() {
    switch (widget.data.theme) {
      case TBTheme.DARK:
        backgroundColor = darkBackground;
        statusBarColor = darkBackground;
        statusBarBrightness = Brightness.dark;
        break;
      default:
        backgroundColor = white;
        statusBarColor = white;
        statusBarBrightness = Brightness.light;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarBrightness: statusBarBrightness,
    ));

    return Container(
      color: backgroundColor,
      child: TBContent(
        data: widget.data,
        scrollActionsProvider: widget.scrollActionsProvider,
      ),
    );

    // final animationController = widget.scrollActionsProvider
    //     ?.getAction(ScrollActionType.elevateTopBar)
    //     ?.animationController;

    // if (animationController == null)
    //   return Container(
    //     color: widget.data.backgroundColor ?? Colors.white,
    //     child: TBContent(
    //       data: widget.data,
    //       scrollActionsProvider: widget.scrollActionsProvider,
    //     ),
    //   );

    // final animation =
    //     Tween<double>(begin: 0, end: 1).animate(animationController);

    // return AnimatedBuilder(
    //   animation: animation,
    //   builder: (context, child) => Container(
    //     child: child,
    //     decoration: BoxDecoration(
    //       color: widget.data.backgroundColor ?? Colors.white,
    //       boxShadow: [
    //         BoxShadow.lerp(flatShadow, elevatedShadow, animation.value)
    //       ],
    //     ),
    //   ),
    //   child: TBContent(
    //     data: widget.data,
    //     scrollActionsProvider: widget.scrollActionsProvider,
    //   ),
    // );
  }
}
