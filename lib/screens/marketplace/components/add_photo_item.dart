import 'dart:io';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/marketplace/pages/photos_page.dart';

class AddPhotoItem extends StatelessWidget {
  final Function(PhotoItemData) onPush;
  final PhotoItemData photoItemData;

  const AddPhotoItem({Key key, this.onPush, this.photoItemData}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onPush(photoItemData),
        child: Container(
          height: 160,
          decoration: ShapeDecoration(
            color: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          child: photoItemData.file == null
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
                        photoItemData.title,
                        style: Theme.of(context).textTheme.subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Image.file(photoItemData.file, fit: BoxFit.cover),
        ),
      );
}
