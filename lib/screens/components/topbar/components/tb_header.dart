import 'package:flutter/material.dart';

class TBHeader extends StatelessWidget {
  final String text;

  const TBHeader({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == null) return SizedBox();

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
