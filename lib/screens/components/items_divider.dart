import 'package:flutter/material.dart';

class ItemsDivider extends StatelessWidget {
  final double padding;

  const ItemsDivider({Key key, this.padding = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Container(
        height: 1,
        color: Color(0xFFE6E6E6),
      ),
    );
  }
}
