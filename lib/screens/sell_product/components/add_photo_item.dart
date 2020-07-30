import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddPhotoItem extends StatelessWidget {
  final Function(int) onPush;
  final type;
  final File image;

  const AddPhotoItem({Key key, this.type, this.onPush, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => {
        onPush(type),
      },
      child: new Container(
        height: 140,
        color: Color(0xFFF4F4F4),
        child: (image == null)
            ? Container(
                margin: const EdgeInsets.only(top: 48),
                child: Column(children: [
                  Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/camera.svg',
                        color: Colors.black,
                        width: 24,
                        height: 24,
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 12),
                      alignment: Alignment.center,
                      child: Text(
                        getTitle(),
                        style: textTheme.subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                ]))
            : Container(
                child: Image.file(image, fit: BoxFit.cover),
              ),
      ),
    );
  }

  String getTitle() {
    switch (type) {
      case 1:
        return "Вид спереди";
      case 2:
        return "Вид сзади";
      case 3:
        return "Вид сбоку";
    }
  }
}
