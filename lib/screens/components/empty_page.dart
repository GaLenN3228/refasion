import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final Function() onPush;
  final String text;

  const EmptyPage({Key key, this.text, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onPush,
          child: Text(
            text ?? "Даже текст не задали :(",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }
}
