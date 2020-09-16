import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/radio_button/stateless.dart';

class RefashionedRadioButtonStateful extends StatefulWidget {
  final bool value;

  final double size;
  final EdgeInsets padding;
  final Function(bool) onUpdate;

  const RefashionedRadioButtonStateful(
      {Key key,
      this.value: false,
      this.size,
      this.padding: EdgeInsets.zero,
      this.onUpdate})
      : super(key: key);

  @override
  _RefashionedRadioButtonStatefulState createState() =>
      _RefashionedRadioButtonStatefulState();
}

class _RefashionedRadioButtonStatefulState
    extends State<RefashionedRadioButtonStateful> {
  bool value;

  @override
  initState() {
    value = widget.value;

    super.initState();
  }

  update() {
    if (widget.onUpdate != null) {
      widget.onUpdate(!value);
      setState(() => value = !value);
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: update,
        child: RefashionedRadioButtonStateless(
          padding: widget.padding,
          size: widget.size,
          value: value,
        ),
      );
}
