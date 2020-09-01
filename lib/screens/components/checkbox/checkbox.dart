import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/checkbox/content.dart';

class RefashionedCheckbox extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier;
  final bool value;

  final double size;

  const RefashionedCheckbox(
      {Key key, this.valueNotifier, this.value: false, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (valueNotifier != null)
      return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, newvalue, child) => CheckboxContent(
          value: newvalue,
          size: size,
        ),
      );

    return CheckboxContent(
      value: value,
      size: size,
    );
  }
}
