import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/components/scaffold/data/children_data.dart';

class ScaffoldChildrenContent extends StatefulWidget {
  final ScaffoldChildrenData data;
  final ScrollController scrollController;
  final ValueNotifier<EdgeInsets> padding;

  const ScaffoldChildrenContent(
      {Key key, this.data, this.scrollController, this.padding})
      : super(key: key);

  @override
  _ScaffoldChildrenContentState createState() =>
      _ScaffoldChildrenContentState();
}

class _ScaffoldChildrenContentState extends State<ScaffoldChildrenContent>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<EdgeInsets> animation;

  EdgeInsets currentPadding;

  @override
  void initState() {
    currentPadding = widget.padding?.value ?? EdgeInsets.zero;

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    animation = Tween<EdgeInsets>(begin: currentPadding, end: currentPadding)
        .animate(animationController);

    widget.padding?.addListener(paddingListener);

    super.initState();
  }

  paddingListener() {
    animation =
        Tween<EdgeInsets>(begin: currentPadding, end: widget.padding?.value)
            .animate(animationController);

    animationController
        .forward(from: 0.0)
        .then((_) => currentPadding = widget.padding?.value);
  }

  @override
  void dispose() {
    widget.padding?.removeListener(paddingListener);

    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final topPadding = AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Container(
        // color: Colors.red,
        width: double.infinity,
        height: animation.value.top,
      ),
    );

    final bottomPadding = AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Container(
        // color: Colors.red,
        width: double.infinity,
        height: animation.value.bottom != 0
            ? screenHeight - animation.value.bottom
            : 0,
      ),
    );

    if (widget.data.child != null)
      return Column(
        children: [
          topPadding,
          Expanded(
            child: widget.data.child,
          ),
          bottomPadding
        ],
      );

    if (widget.data.children != null)
      return ListView(
        controller: widget.scrollController,
        padding: EdgeInsets.zero,
        children: [
          ...[topPadding],
          ...widget.data.children,
          ...[bottomPadding],
        ],
      );

    if (widget.data.itemCount != null && widget.data.itemBuilder != null) {
      if (widget.data.separatorBuilder != null)
        return ListView.separated(
          padding: EdgeInsets.zero,
          controller: widget.scrollController,
          itemBuilder: (context, index) {
            if (index == 0)
              return Column(
                children: [
                  topPadding,
                  widget.data.itemBuilder(context, index),
                ],
              );

            if (index == widget.data.itemCount - 1)
              return Column(
                children: [
                  widget.data.itemBuilder(context, index),
                  bottomPadding,
                ],
              );

            return widget.data.itemBuilder(context, index);
          },
          separatorBuilder: widget.data.separatorBuilder,
          itemCount: widget.data.itemCount,
        );
      else
        return ListView.builder(
          padding: EdgeInsets.zero,
          controller: widget.scrollController,
          itemBuilder: (context, index) {
            if (index == 0)
              return Column(
                children: [
                  topPadding,
                  widget.data.itemBuilder(context, index),
                ],
              );

            if (index == widget.data.itemCount - 1)
              return Column(
                children: [
                  widget.data.itemBuilder(context, index),
                  bottomPadding,
                ],
              );

            return widget.data.itemBuilder(context, index);
          },
          itemCount: widget.data.itemCount,
        );
    }

    return Column(
      children: [
        topPadding,
        Expanded(
          child: Center(
            child: Text(
              widget.data.message ?? "Не переданы данные",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        bottomPadding
      ],
    );
  }
}
