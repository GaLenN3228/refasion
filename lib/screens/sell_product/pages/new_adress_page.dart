import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewAdressPage extends StatelessWidget {
  final Function() onPush;

  const NewAdressPage({Key key, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onPush,
            child: Text("Новый адрес")),
      ),
    );
  }
}
