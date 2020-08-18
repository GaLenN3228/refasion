import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/multi_selection_dialog/dialog.dart' as MultiSelectionDialog;
import 'package:refashioned_app/screens/multi_selection_dialog/dialog_item.dart';
import 'package:refashioned_app/screens/sell_product/components/add_photo_description_item.dart';
import 'package:refashioned_app/screens/sell_product/components/add_photo_item.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class PhotosPage extends StatefulWidget {
  final Function() onPush;
  final Function() onClose;

  const PhotosPage({Key key, this.onPush, this.onClose}) : super(key: key);

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  final picker = ImagePicker();
  Map<int, File> images = {0: null, 1: null, 2: null};

  Future getImage(int index) async {
    showDialog(
        context: context,
        builder: (dialogContext) => MultiSelectionDialog.Dialog(
              dialogContent: [
                DialogItemContent("Сделать фото", () {
                  openCamera(index);
                }, DialogItemType.item, icon: "assets/camera_small.svg"),
                DialogItemContent("Выбрать из галереи", () {
                  openGallery(index);
                }, DialogItemType.item, icon: "assets/gallery_small.svg"),
                DialogItemContent("Закрыть", () {
                  Navigator.pop(dialogContext);
                }, DialogItemType.system)
              ],
            ));
  }

  Future openGallery(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null)
      setState(() {
        File _image = File(pickedFile.path);
        images[index] = _image;
      });
  }

  Future openCamera(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null)
      setState(() {
        File _image = File(pickedFile.path);
        images[index] = _image;
      });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Column(
            children: [
              RefashionedTopBar(
                leftButtonType: TBButtonType.icon,
                leftButtonIcon: TBIconType.back,
                leftButtonAction: () => Navigator.of(context).pop(),
                middleType: TBMiddleType.title,
                middleTitleText: "Добавить вещь",
                rightButtonType: TBButtonType.text,
                rightButtonText: "Закрыть",
                rightButtonAction: widget.onClose,
                bottomType: TBBottomType.header,
                bootomHeaderText: "Внешний вид",
              ),
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
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomButton(
                title: "ПРОДОЛЖИТЬ",
                action: widget.onPush,
              )),
        ],
      ),
    );
  }
}
