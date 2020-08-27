import 'dart:io';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class AddPhotoItem extends StatelessWidget {
  final Function(int) onPush;
  final int type;
  final File image;

  const AddPhotoItem({Key key, this.type, this.onPush, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onPush(type),
        child: Container(
          height: 160,
          decoration: ShapeDecoration(
            color: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          child: image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SVGIcon(
                      icon: IconAsset.camera,
                      size: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        getTitle(),
                        style: Theme.of(context).textTheme.subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Image.file(image, fit: BoxFit.cover),
        ),
      );

  String getTitle() {
    switch (type) {
      case 0:
        return "Вид спереди";
      case 1:
        return "Вид сзади";
      case 2:
        return "Вид сбоку";
      default:
        return "Больше фото";
    }
  }
}
