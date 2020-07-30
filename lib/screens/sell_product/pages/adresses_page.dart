import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdressesPage extends StatelessWidget {
  final Function() onPush;

  const AdressesPage({Key key, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onPush,
            child: Text("Адреса")),
      ),
    );
  }
}
