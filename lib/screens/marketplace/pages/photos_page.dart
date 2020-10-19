import 'dart:ffi';
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
import 'package:refashioned_app/screens/marketplace/components/add_photo_item.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class PhotoItemData {
  int index;
  File file;
  String title;

  PhotoItemData(this.index, this.file, this.title);
}

class PhotosPage extends StatefulWidget {
  final Function() onClose;
  final Function(List<PhotoItemData>) onPush;
  final Function(File) onUpdate;

  const PhotosPage({Key key, this.onPush, this.onClose, this.onUpdate}) : super(key: key);

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  BuildContext dialogContext;

  final picker = ImagePicker();
  List<PhotoItemData> images = List();

  @override
  void initState() {
    images.add(PhotoItemData(0, null, "Вид спереди"));
    images.add(PhotoItemData(1, null, "Вид сзади"));
    images.add(PhotoItemData(2, null, "Вид сбоку"));
    super.initState();
  }

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
              if (images[index] != null && images[index].file != null)
                DialogItemContent(
                  DialogItemType.item,
                  title: "Удалить",
                  onClick: () async {
                    removePhotoFromCollection(index);
                    Navigator.pop(dialogContext);
                  },
                  icon: IconAsset.delete,
                  color: Colors.red,
                ),
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
      addPhotoToCollection(index, pickedFile.path);
      Navigator.pop(dialogContext);
    }
  }

  Future openCamera(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      addPhotoToCollection(index, pickedFile.path);
      Navigator.pop(dialogContext);
    }
  }

  void addPhotoToCollection(int index, String imagePath) {
    setState(() {
      File _image = File(imagePath);
      images[index].file = _image;
      if (images.every((element) => element.file != null) && images.length < 10)
        images.add(PhotoItemData(images.length, null, "Больше фото"));
    });
  }

  void removePhotoFromCollection(int index) {
    setState(() {
      if (index == 0 || index == 1 || index == 2) {
        images[index].file = null;
        images.removeWhere((element) =>
            element.index != 0 && element.index != 1 && element.index != 2 && element.file == null);
      } else {
        images.removeAt(index);
      }
    });
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
                  bottomText: "Добавьте фотографии",
                ),
              ),
              Expanded(
                child: StaggeredGridView.countBuilder(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 76),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) =>
                      // index == images.length
                      //     ? Container(
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         alignment: Alignment.centerLeft,
                      //         child: Text(
                      //           "Информация для размещения",
                      //           style: Theme
                      //               .of(context)
                      //               .textTheme
                      //               .headline1,
                      //         ),
                      //       ),
                      //       AddPhotoDescriptionItem(
                      //           title: "Сфотографируйте все имеющиеся деффекты"),
                      //       AddPhotoDescriptionItem(
                      //           title: "Сделайте фото бирки и ото этикетки с размером"),
                      //       AddPhotoDescriptionItem(title: "Используйте нейтральный фон"),
                      //     ],
                      //   ),
                      // )
                      //     :
                      AddPhotoItem(
                          photoItemData: images[index],
                          onPush: (type) {
                            getImage(index);
                          }),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
              )
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomButton(
                title: "ПРОДОЛЖИТЬ",
                enabled: images.any((element) => element.file != null),
                action: () {
                  widget.onPush(images.where((element) => element.file != null).toList());
                },
              )),
        ],
      ),
    );
  }
}
