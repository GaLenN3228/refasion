import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_search.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';
import 'package:refashioned_app/utils/colors.dart';

class TBMiddle extends StatefulWidget {
  final TBMiddleData data;
  final TBSearchData searchData;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  const TBMiddle(
      {Key key, this.data, this.scrollActionsProvider, this.searchData})
      : assert(data != null);

  @override
  _TBMiddleState createState() => _TBMiddleState();
}

class _TBMiddleState extends State<TBMiddle>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    switch (widget.data.type) {
      case TBMiddleType.title:
        if (widget.data.titleText == null || widget.data.titleText.isEmpty)
          return SizedBox();

        return Text(
          widget.data.titleText.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        );

      case TBMiddleType.condensed:
        if (widget.data.titleText == null ||
            widget.data.titleText.isEmpty ||
            widget.data.subtitleText == null ||
            widget.data.subtitleText.isEmpty ||
            widget.scrollActionsProvider == null) return SizedBox();

        final animationController = widget.scrollActionsProvider
            ?.getAction(ScrollActionType.fadeTopBarMiddle)
            ?.animationController;

        if (animationController == null) return SizedBox();

        final animation =
            Tween<double>(begin: 0, end: 1).animate(animationController);

        return FadeTransition(
          opacity: animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.data.titleText,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontWeight: FontWeight.normal),
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              Text(
                widget.data.subtitleText,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: darkGrayColor),
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        );

      case TBMiddleType.search:
        return TBSearch(
          data: widget.searchData,
          scrollActionsProvider: widget.scrollActionsProvider,
        );

      default:
        return SizedBox();
    }
  }
}
