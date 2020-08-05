import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/sell_product/components/add_photo_description_item.dart';
import 'package:refashioned_app/screens/sell_product/components/add_photo_item.dart';
import 'package:refashioned_app/screens/sell_product/components/header.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class PhotosPage extends StatefulWidget {
  final Function(List<String>) onPush;

  const PhotosPage({Key key, this.onPush}) : super(key: key);

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  final picker = ImagePicker();
  Map<int, File> images = {0: null, 1: null, 2: null};

  Future getImage(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      File _image = File(pickedFile.path);
      images[index] = _image;
    });
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
        child: Column(children: [
      Column(children: [
        SellProductTopBar(),
        Header(text: "Внешний вид"),
      ]),
      StaggeredGridView.countBuilder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        shrinkWrap: true,
        crossAxisCount: 2,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) => AddPhotoItem(
            type: index,
            image: images[index],
            onPush: (type) {
              getImage(index);
            }),
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      Expanded(
          child: Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            "Информация для размещения",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        AddPhotoDescriptionItem(title: "Сфотографируйте все имеющиеся деффекты"),
        AddPhotoDescriptionItem(title: "Сделайте фото бирки и ото этикетки с размером"),
        AddPhotoDescriptionItem(title: "Используйте нейтральный фон"),
      ])),
      Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomButton(
            title: "ПРОДОЛЖИТЬ",
            action: () {
              widget.onPush(null);
            },
          )),
    ]));
  }
}