import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/brand.dart';

class BrandPage extends StatelessWidget {
  final Function(Brand) onPush;

  const BrandPage({Key key, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onPush(null),
            child: Text("Бренд")),
      ),
    );
  }
}
