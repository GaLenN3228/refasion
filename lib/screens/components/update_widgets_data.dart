import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:refashioned_app/repositories/sizes.dart';

class UpdateWidgetsData extends StatefulWidget {
  final Widget child;
  final SizesProvider sizesProvider;
  final List<WidgetData> widgetsToUpdate;
  final Function() onUpdate;

  const UpdateWidgetsData({
    this.child,
    this.sizesProvider,
    this.widgetsToUpdate,
    this.onUpdate,
  }) : assert(
            child != null && sizesProvider != null && widgetsToUpdate != null);

  @override
  _UpdateWidgetsDataState createState() => _UpdateWidgetsDataState();
}

class _UpdateWidgetsDataState extends State<UpdateWidgetsData> {
  @override
  Widget build(BuildContext context) {
    if (widget.widgetsToUpdate != null)
      SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);

    return widget.child;
  }

  void postFrameCallback(_) {
    Future.delayed(const Duration(milliseconds: 0)).then(
      (_) {
        bool shouldRebuild = false;

        for (final data in widget.widgetsToUpdate) {
          final key = data.key;

          final context = key.currentContext;

          if (context == null) return;

          final renderBox = context.findRenderObject() as RenderBox;

          final size = renderBox.size;

          final position = renderBox.localToGlobal(Offset.zero);

          shouldRebuild = shouldRebuild ||
              widget.sizesProvider.update(
                  name: data.name,
                  key: key,
                  width: size.width,
                  height: size.height,
                  dx: position.dx,
                  dy: position.dy);
        }

        if (shouldRebuild && widget.onUpdate != null) widget.onUpdate();
      },
    );
  }
}
