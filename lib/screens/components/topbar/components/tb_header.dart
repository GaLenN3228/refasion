import 'package:flutter/material.dart';

class TBHeader extends StatelessWidget {
  final String text;

  const TBHeader({this.text}) : assert(text != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 16),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
