import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnModerationPage extends StatelessWidget {
  final Function() onClose;

  const OnModerationPage({Key key, this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onClose,
            child: Text("На модерации")),
      ),
    );
  }
}
