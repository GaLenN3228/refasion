import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/scaffold/components/children_content.dart';
import 'package:refashioned_app/screens/components/scaffold/data/children_data.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_data.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/components/update_widgets_data.dart';

class ScaffoldContent extends StatefulWidget {
  final ScaffoldData scaffoldData;

  const ScaffoldContent({Key key, this.scaffoldData}) : super(key: key);

  @override
  _ScaffoldContentState createState() => _ScaffoldContentState();
}

class _ScaffoldContentState extends State<ScaffoldContent>
    with TickerProviderStateMixin {
  ScrollController scrollController;

  SizesProvider sizesProvider;
  ScaffoldScrollActionsProvider scrollActionsProvider;

  WidgetData topBarWidgetData;
  WidgetData bottomOverlayWidgetData;
  double bottomNavTopOffset;
  double topBarBottomOffset;
  double bottomOverlayTopOffsetFromBottom;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);

    sizesProvider = Provider.of<SizesProvider>(context, listen: false);
    scrollActionsProvider = ScaffoldScrollActionsProvider(
        shouldElevateOnScroll:
            widget.scaffoldData.topBarData.shouldElevateOnScroll);

    final bottomNavData = sizesProvider.getData("bottomNav");
    bottomNavTopOffset = bottomNavData?.dy ?? 0;
    topBarWidgetData =
        sizesProvider.getData("topBar") ?? WidgetData.create("topBar");
    topBarBottomOffset = topBarWidgetData != null
        ? topBarWidgetData.dy + topBarWidgetData.height
        : 0;
    bottomOverlayWidgetData = sizesProvider.getData("bottomOverlay") ??
        WidgetData.create("bottomOverlay");
    bottomOverlayTopOffsetFromBottom = 0;

    super.initState();
  }

  updateSizes() {
    final screenHeight = MediaQuery.of(context).size.height;

    final topBarData = sizesProvider.getData("topBar");
    final bottomOverlayData = sizesProvider.getData("bottomOverlay");
    final newTopBarBottomOffset =
        topBarData != null ? topBarData.dy + topBarData.height : 0;
    final newBottomOverlayTopOffsetFromBottom =
        bottomOverlayData != null ? screenHeight - bottomOverlayData.dy : 0;

    if (newTopBarBottomOffset != topBarBottomOffset ||
        newBottomOverlayTopOffsetFromBottom != bottomOverlayTopOffsetFromBottom)
      setState(() {
        updateActionsData();

        topBarBottomOffset = newTopBarBottomOffset.toDouble();

        bottomOverlayTopOffsetFromBottom =
            newBottomOverlayTopOffsetFromBottom.toDouble();
      });
  }

  updateActionsData() {
    if (widget.scaffoldData.topBarData.shouldElevateOnScroll)
      scrollActionsProvider.setAction(
          ScrollActionType.elevateTopBar,
          0,
          new AnimationController(
              vsync: this, duration: const Duration(milliseconds: 200)));

    if (widget.scaffoldData.scrollActions != null)
      widget.scaffoldData.scrollActions.forEach((key, value) {
        final newData = sizesProvider.getData(key.name);
        if (newData != null)
          scrollActionsProvider.setAction(
              value.type,
              newData.dy,
              new AnimationController(
                  vsync: this, duration: const Duration(milliseconds: 200)));
      });
  }

  scrollListener() => scrollActionsProvider.update(scrollController.offset);

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();

    scrollActionsProvider.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: widget.scaffoldData.resizeToAvoidBottomInset,
      backgroundColor: Colors.blue,
      child: UpdateWidgetsData(
        widgetsToUpdate: [topBarWidgetData, bottomOverlayWidgetData]
          ..addAll(widget.scaffoldData.scrollActions?.keys ?? []),
        sizesProvider: sizesProvider,
        onUpdate: updateSizes,
        child: Material(
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.scaffoldData.childrenDataStream != null
                  ? StreamBuilder<ScaffoldChildrenData>(
                      stream: widget.scaffoldData.childrenDataStream,
                      builder: (context, childrenDataSnapshot) {
                        ScaffoldChildrenData childrenData;

                        if (childrenDataSnapshot.hasError)
                          childrenData = ScaffoldChildrenData(
                              message: childrenDataSnapshot.error.toString());
                        else if (!childrenDataSnapshot.hasData)
                          childrenData = widget.scaffoldData.childrenData ??
                              ScaffoldChildrenData(
                                  message: "Не переданы данные");
                        else
                          childrenData = childrenDataSnapshot.data;

                        return ScaffoldChildrenContent(
                          data: childrenData,
                          scrollController: scrollController,
                          padding: EdgeInsets.only(
                              top: topBarBottomOffset,
                              bottom: bottomOverlayTopOffsetFromBottom),
                        );
                      },
                    )
                  : ScaffoldChildrenContent(
                      data: widget.scaffoldData.childrenData ??
                          ScaffoldChildrenData(message: "Не переданы данные"),
                      scrollController: scrollController,
                      padding: EdgeInsets.only(
                          top: topBarBottomOffset,
                          bottom: bottomOverlayTopOffsetFromBottom),
                    ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  key: topBarWidgetData.key,
                  child: RefashionedTopBar(
                    data: widget.scaffoldData.topBarData,
                    scrollActionsProvider: scrollActionsProvider,
                  ),
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
