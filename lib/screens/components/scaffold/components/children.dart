import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/scaffold/components/children_content.dart';
import 'package:refashioned_app/screens/components/scaffold/data/children_data.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_builder_data.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_data.dart';

class ScaffoldChildren extends StatefulWidget {
  final ScaffoldData scaffoldData;
  final ScaffoldBuilderData scaffoldBuilderData;
  final ScaffoldScrollActionsProvider scaffoldScrollActionsProvider;
  final ValueNotifier<EdgeInsets> contentPadding;

  const ScaffoldChildren(
      {Key key,
      this.scaffoldData,
      this.scaffoldBuilderData,
      this.scaffoldScrollActionsProvider,
      this.contentPadding})
      : super(key: key);
  @override
  _ScaffoldChildrenState createState() => _ScaffoldChildrenState();
}

class _ScaffoldChildrenState extends State<ScaffoldChildren> {
  ScrollController scrollController;

  @override
  initState() {
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);

    super.initState();
  }

  scrollListener() =>
      widget.scaffoldScrollActionsProvider?.update(scrollController.offset);

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget childrenContent = SizedBox();

    if (widget.scaffoldData.childrenDataStream != null)
      childrenContent = StreamBuilder<ScaffoldChildrenData>(
        stream: widget.scaffoldData.childrenDataStream,
        builder: (context, childrenDataSnapshot) {
          ScaffoldChildrenData childrenData;

          if (childrenDataSnapshot.hasError)
            childrenData = ScaffoldChildrenData.message(
                childrenDataSnapshot.error.toString());
          else if (!childrenDataSnapshot.hasData)
            childrenData = widget.scaffoldData.childrenData ??
                ScaffoldChildrenData.message("Не переданы данные");
          else
            childrenData = childrenDataSnapshot.data;

          return ScaffoldChildrenContent(
            data: childrenData,
            scrollController: scrollController,
            padding: widget.contentPadding,
          );
        },
      );
    else
      childrenContent = ScaffoldChildrenContent(
        data: widget.scaffoldData.childrenData ??
            ScaffoldChildrenData.message("Не переданы данные"),
        scrollController: scrollController,
        padding: widget.contentPadding,
      );

    if (widget.scaffoldBuilderData?.animation != null)
      childrenContent = SlideTransition(
          position: widget.scaffoldBuilderData.animation
              .drive(Tween(begin: Offset(1, 0), end: Offset.zero)),
          child: childrenContent);

    if (widget.scaffoldBuilderData?.secondaryAnimation != null)
      childrenContent = SlideTransition(
          position: widget.scaffoldBuilderData.secondaryAnimation
              .drive(Tween(begin: Offset.zero, end: Offset(-1, 0))),
          child: childrenContent);

    return Material(
      color: Colors.white,
      child: childrenContent,
    );
  }
}
