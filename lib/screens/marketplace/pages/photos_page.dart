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
  final Function(String url, String title) openInfoWebViewBottomSheet;

  const PhotosPage({Key key, this.onPush, this.onClose, this.onUpdate, this.openInfoWebViewBottomSheet})
      : super(key: key);

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
    images.add(PhotoItemData(2, null, "Фото бирки"));
    images.add(PhotoItemData(3, null, "Больше фото"));
    super.initState();
  }

  Future getImage(int index) async {
    showDialog(
        context: context,
        builder: (dialogContext) {
          this.dialogContext = dialogContext;
          return CustomDialog.Dialog(
            dialogContent: [
              DialogItemContent(
                DialogItemType.item,
                title: "Сделать фото",
                onClick: () => openCamera(index),
                icon: IconAsset.camera,
              ),
              DialogItemContent(
                DialogItemType.item,
                title: "Выбрать из галереи",
                onClick: () => openGallery(index),
                icon: IconAsset.image,
              ),
              if (images[index] != null && images[index].file != null)
                DialogItemContent(
                  DialogItemType.item,
                  title: "Удалить",
                  onClick: () => removePhotoFromCollection(index),
                  icon: IconAsset.delete,
                  color: Colors.red,
                ),
              DialogItemContent(
                DialogItemType.system,
                title: "Закрыть",
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
      if (index == 0 || index == 1 || index == 2 || index == 3) if (index == 3 && images.length > 4)
        images.removeAt(index);
      else
        images[index].file = null;
      else {
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
                  itemCount: images.length + 1,
                  itemBuilder: (BuildContext context, int index) => index == images.length
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () =>
                                widget.openInfoWebViewBottomSheet("https://refashioned.ru/photo", "ДОБАВЛЕНИЕ ФОТО"),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SVGIcon(
                                  icon: IconAsset.info,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Как правильно разместить фотографии?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(decoration: TextDecoration.underline, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        )
                      : AddPhotoItem(
                          photoItemData: images[index],
                          onPush: (type) {
                            getImage(index);
                          }),
                  staggeredTileBuilder: (int index) =>
                      index == images.length ? new StaggeredTile.fit(2) : new StaggeredTile.fit(1),
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
