import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/checkbox/content.dart';

class RefashionedCheckboxListenable extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier;

  final double size;

  const RefashionedCheckboxListenable({Key key, this.valueNotifier, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, newvalue, child) => CheckboxContent(
          value: newvalue,
          size: size,
        ),
      );
}
