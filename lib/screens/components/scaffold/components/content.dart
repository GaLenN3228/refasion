import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/scaffold/components/children.dart';
import 'package:refashioned_app/screens/components/scaffold/components/search_results.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_builder_data.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_data.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/components/scaffold/components/collect_widgets_data.dart';

class ScaffoldContent extends StatefulWidget {
  final ScaffoldData scaffoldData;
  final ScaffoldBuilderData scaffoldBuilderData;

  const ScaffoldContent({Key key, this.scaffoldData, this.scaffoldBuilderData})
      : super(key: key);

  @override
  _ScaffoldContentState createState() => _ScaffoldContentState();
}

class _ScaffoldContentState extends State<ScaffoldContent>
    with TickerProviderStateMixin {
  SizesProvider sizesProvider;
  ScaffoldScrollActionsProvider scrollActionsProvider;

  WidgetData topBarWidgetData;
  WidgetData bottomOverlayWidgetData;
  double bottomNavTopOffset;
  double topBarBottomOffset;
  double bottomOverlayTopOffset;

  ValueNotifier<EdgeInsets> contentPadding;

  @override
  void initState() {
    sizesProvider = Provider.of<SizesProvider>(context, listen: false);

    scrollActionsProvider = ScaffoldScrollActionsProvider(
        shouldElevateOnScroll:
            widget.scaffoldData.topBarData.shouldElevateOnScroll);

    bottomNavTopOffset = sizesProvider.getData("bottomNav")?.dy ?? 0;

    topBarWidgetData =
        sizesProvider.getData("topBar") ?? WidgetData.create("topBar");

    topBarBottomOffset = topBarWidgetData != null
        ? topBarWidgetData.dy + topBarWidgetData.height
        : 0;

    bottomOverlayWidgetData = sizesProvider.getData("bottomOverlay") ??
        WidgetData.create("bottomOverlay");

    bottomOverlayTopOffset = bottomOverlayWidgetData.dy;

    contentPadding = ValueNotifier(EdgeInsets.only(
      top: topBarBottomOffset,
      bottom: bottomOverlayTopOffset,
    ));

    super.initState();
  }

  updateSizes() {
    if (widget.scaffoldData.adjustToOverlays) {
      final topBarData = sizesProvider.getData("topBar");

      final newTopBarBottomOffset = topBarData != null ? topBarData.height : 0;

      final newBottomOverlayTopOffset =
          sizesProvider.getData("bottomOverlay")?.dy ?? 0;

      if (newTopBarBottomOffset != topBarBottomOffset ||
          newBottomOverlayTopOffset != bottomOverlayTopOffset) {
        updateActionsData();

        contentPadding.value = EdgeInsets.only(
          top: topBarBottomOffset = newTopBarBottomOffset,
          bottom: bottomOverlayTopOffset = newBottomOverlayTopOffset,
        );
      }
    }
  }

  AnimationController createAnimAtionController() => new AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));

  updateActionsData() {
    if (widget.scaffoldData.topBarData.shouldElevateOnScroll)
      scrollActionsProvider.setAction(
          ScrollActionType.elevateTopBar, 0, createAnimAtionController());

    if (widget.scaffoldData.scrollActions != null)
      widget.scaffoldData.scrollActions.forEach(
        (key, value) {
          final newData = sizesProvider.getData(key.name);
          if (newData != null)
            scrollActionsProvider.setAction(
              value.type,
              newData.dy,
              createAnimAtionController(),
            );
        },
      );
  }

  @override
  void dispose() {
    contentPadding.dispose();

    scrollActionsProvider.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: widget.scaffoldData.resizeToAvoidBottomInset,
      child: CollectWidgetsData(
        millisecondsDelay: 500,
        widgets: [topBarWidgetData, bottomOverlayWidgetData]
          ..addAll(widget.scaffoldData.scrollActions?.keys ?? []),
        sizesProvider: sizesProvider,
        onChange: updateSizes,
        child: Stack(
          children: [
            ScaffoldChildren(
              scaffoldBuilderData: widget.scaffoldBuilderData,
              scaffoldData: widget.scaffoldData,
              scaffoldScrollActionsProvider: scrollActionsProvider,
              contentPadding: contentPadding,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: widget.scaffoldData.coveredWithBottomNav
                  ? mediaQuery.size.height - bottomNavTopOffset
                  : mediaQuery.padding.bottom,
              child: SizedBox(
                key: bottomOverlayWidgetData.key,
                child: widget.scaffoldData.bottomOverlay ?? SizedBox(),
              ),
            ),
            Positioned.fill(
              child: ScaffoldSearchResults(
                scaffoldBuilderData: widget.scaffoldBuilderData,
                scaffoldData: widget.scaffoldData,
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: RefashionedTopBar(
                key: topBarWidgetData.key,
                data: widget.scaffoldData.topBarData,
                scrollActionsProvider: scrollActionsProvider,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
