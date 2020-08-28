import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:refashioned_app/repositories/sizes.dart';

class CollectWidgetsData extends StatefulWidget {
  final Widget child;
  final SizesProvider sizesProvider;
  final List<WidgetData> widgets;
  final int millisecondsDelay;
  final Function() onChange;

  const CollectWidgetsData({
    this.child,
    this.sizesProvider,
    this.widgets,
    this.onChange,
    this.millisecondsDelay: 0,
  }) : assert(child != null && sizesProvider != null && widgets != null);

  @override
  _CollectWidgetsDataState createState() => _CollectWidgetsDataState();
}

class _CollectWidgetsDataState extends State<CollectWidgetsData> {
  @override
  Widget build(BuildContext context) {
    if (widget.widgets != null)
      SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);

    return widget.child;
  }

  void postFrameCallback(_) {
    Future.delayed(Duration(milliseconds: widget.millisecondsDelay)).then(
      (_) {
        bool hasChanges = false;

        for (final data in widget.widgets) {
          final key = data.key;

          final context = key.currentContext;

          if (context == null) return;

          final renderBox = context.findRenderObject() as RenderBox;

          final size = renderBox.size;

          final position = renderBox.localToGlobal(Offset.zero);

          hasChanges = hasChanges ||
              widget.sizesProvider.update(
                  name: data.name,
                  key: key,
                  width: size.width,
                  height: size.height,
                  dx: position.dx,
                  dy: position.dy);
        }

        if (hasChanges && widget.onChange != null) widget.onChange();
      },
    );
  }
}
