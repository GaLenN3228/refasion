import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotosPage extends StatelessWidget {
  final Function(List<String>) onPush;

  const PhotosPage({Key key, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onPush(null),
            child: Text("Фото")),
      ),
    );
  }
}
