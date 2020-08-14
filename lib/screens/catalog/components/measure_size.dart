import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MeasureSize extends StatefulWidget {
  final Widget child;
  final Function(Size, Offset) onChange;

  const MeasureSize({
    Key key,
    @required this.onChange,
    @required this.child,
  }) : super(key: key);

  @override
  _MeasureSizeState createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  GlobalKey widgetKey;

  Size oldSize;
  Offset oldPosition;

  @override
  initState() {
    widgetKey = GlobalKey();

    oldSize = Size.zero;
    oldPosition = Offset.zero;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  void postFrameCallback(_) {
    final context = widgetKey.currentContext;

    if (context == null) return;

    final renderBox = context.findRenderObject() as RenderBox;

    final newSize = renderBox.size;

    final newPosition = renderBox.localToGlobal(Offset.zero);

    if (oldSize == newSize && newPosition == oldPosition) return;

    oldSize = newSize;
    oldPosition = newPosition;

    widget.onChange(newSize, newPosition);
  }
}
