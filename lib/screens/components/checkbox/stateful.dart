import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/checkbox/stateless.dart';

class RefashionedCheckboxStateful extends StatefulWidget {
  final bool value;
  final bool enabled;

  final double size;
  final EdgeInsets padding;
  final Function(bool) onUpdate;

  const RefashionedCheckboxStateful({
    Key key,
    this.value: false,
    this.size: 20,
    this.padding: EdgeInsets.zero,
    this.onUpdate,
    this.enabled: true,
  }) : super(key: key);

  @override
  _RefashionedCheckboxStatefulState createState() => _RefashionedCheckboxStatefulState();
}

class _RefashionedCheckboxStatefulState extends State<RefashionedCheckboxStateful> {
  bool value;

  @override
  initState() {
    value = widget.value;

    super.initState();
  }

  update() {
    setState(() => value = !value);
    widget.onUpdate?.call(value);
  }

  @override
  Widget build(BuildContext context) => RefashionedCheckboxStateless(
        onUpdate: update,
        padding: widget.padding,
        size: widget.size,
        value: value,
        enabled: widget.enabled,
      );
}
