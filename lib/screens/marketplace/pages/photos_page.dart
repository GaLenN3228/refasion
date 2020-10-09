import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog_item.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog.dart' as CustomDialog;
import 'package:refashioned_app/screens/marketplace/components/add_photo_description_item.dart';
import 'package:refashioned_app/screens/marketplace/components/add_photo_item.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class PhotosPage extends StatefulWidget {
  final Function() onClose;
  final Function(List<File>) onPush;
  final Function(File) onUpdate;

  const PhotosPage({Key key, this.onPush, this.onClose, this.onUpdate}) : super(key: key);

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  BuildContext dialogContext;

  final picker = ImagePicker();
  Map<int, File> images = {0: null, 1: null, 2: null};

  Future getImage(int index) async {
    showDialog(
        context: context,
        builder: (dialogContext) {
          this.dialogContext = dialogContext;
          return CustomDialog.Dialog(
            dialogContent: [
              DialogItemContent(DialogItemType.item, title: "Сделать фото", onClick: () {
                return openCamera(index);
              }, icon: IconAsset.camera),
              DialogItemContent(DialogItemType.item, title: "Выбрать из галереи", onClick: () {
                return openGallery(index);
              }, icon: IconAsset.image),
              DialogItemContent(
                DialogItemType.system,
                title: "Закрыть",
                onClick: () {
                  Navigator.pop(dialogContext);
                },
              )
            ],
          );
        });
  }

  Future openGallery(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        File _image = File(pickedFile.path);
        images[index] = _image;
      });
      Navigator.pop(dialogContext);
    }
  }

  Future openCamera(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        File _image = File(pickedFile.path);
        images[index] = _image;
      });
      Navigator.pop(dialogContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              RefashionedTopBar(
                data: TopBarData.simple(
                  onBack: () => Navigator.of(context).pop(),
                  middleText: "Добавить вещь",
                  onClose: widget.onClose,
                  bottomText: "Внешний вид",
                ),
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
                enabled: images.values.any((element) => element != null),
                action: () {
                  var finalPhotos = List<File>();
                  images.forEach((key, value) {
                    if (value != null) {
                      finalPhotos.add(value);
                    }
                  });
                  widget.onPush(finalPhotos);
                },
              )),
        ],
      ),
    );
  }
}
