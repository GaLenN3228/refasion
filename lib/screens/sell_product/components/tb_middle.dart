import 'package:flutter/material.dart';

enum TBMiddleType { text, search, none }

class TBMiddle extends StatelessWidget {
  final TBMiddleType type;
  final String text;

  const TBMiddle(this.type, {Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TBMiddleType.text:
        return Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        );
      case TBMiddleType.search:
        return SizedBox();
      default:
        return SizedBox();
    }
  }
}
