import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/checkbox/stateless.dart';

class RefashionedCheckboxListenable extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier;
  final bool enabled;
  final EdgeInsets padding;
  final double size;

  const RefashionedCheckboxListenable({Key key, this.valueNotifier, this.size, this.enabled: true, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enabled)
      return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, newvalue, child) => RefashionedCheckboxStateless(
          padding: padding,
          value: newvalue,
          size: size,
          enabled: enabled,
        ),
      );
    else
      return RefashionedCheckboxStateless(
        padding: padding,
        size: size,
        enabled: enabled,
      );
  }
}
