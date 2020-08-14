import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_search.dart';
import 'package:refashioned_app/utils/colors.dart';

enum TBMiddleType { title, condensed, search, none }

class TBMiddle extends StatefulWidget {
  final TBMiddleType type;
  final String titleText;

  final String subtitleText;

  final String searchHintText;
  final Function(String) onSearchUpdate;
  final Function() onSearchFocus;
  final Function() onSearchUnfocus;

  final TBSearchController searchController;

  final ValueNotifier<bool> isElevated;
  final ValueNotifier<bool> isScrolledPastOffset;

  const TBMiddle(this.type,
      {this.titleText,
      this.searchHintText,
      this.onSearchUpdate,
      this.onSearchFocus,
      this.onSearchUnfocus,
      this.searchController,
      this.subtitleText,
      this.isElevated,
      this.isScrolledPastOffset})
      : assert(type != null);

  @override
  _TBMiddleState createState() => _TBMiddleState();
}

class _TBMiddleState extends State<TBMiddle>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> opacityAnimation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    widget.isScrolledPastOffset?.addListener(elevationListener);

    super.initState();
  }

  elevationListener() {
    if (widget.isScrolledPastOffset.value)
      animationController.forward();
    else
      animationController.reverse();
  }

  @override
  void dispose() {
    widget.isScrolledPastOffset?.removeListener(elevationListener);

    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case TBMiddleType.title:
        if (widget.titleText == null || widget.titleText.isEmpty)
          return SizedBox();

        return Text(
          widget.titleText.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        );

      case TBMiddleType.condensed:
        if ((widget.titleText == null || widget.titleText.isEmpty) &&
            (widget.subtitleText == null || widget.subtitleText.isEmpty) &&
            widget.isElevated != null) return SizedBox();

        return FadeTransition(
          opacity: opacityAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.titleText,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontWeight: FontWeight.normal),
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              Text(
                widget.subtitleText,
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
          hintText: widget.searchHintText,
          onSearchUpdate: widget.onSearchUpdate,
          onFocus: widget.onSearchFocus,
          onUnfocus: widget.onSearchUnfocus,
          searchController: widget.searchController,
          isScrolled: widget.isElevated,
        );

      default:
        return SizedBox();
    }
  }
}
