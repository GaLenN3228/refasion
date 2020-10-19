import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/authorization.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/repositories/config.dart';
import 'package:refashioned_app/screens/city_selector/city_selector.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog_item.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog.dart' as CustomDialog;

class UserProfile extends StatefulWidget {
  final Function(String, String) onDocPush;

  final Function() onMapPageClick;

  const UserProfile({Key key, this.onMapPageClick, this.onDocPush}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  BuildContext dialogContext;

  final picker = ImagePicker();

  String userPhoto;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Material(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RefashionedTopBar(
              data: TopBarData.simple(
                onBack: () => Navigator.of(context).pop(),
                middleText: "МОЙ ПРОФИЛЬ",
              ),
            ),
            _appBar(context),
            Container(
              padding: EdgeInsets.only(left: 20, top: 14, bottom: 14),
              width: double.infinity,
              color: Color(0xFFF2F2F2),
              child: Text(
                "МОИ ДАННЫЕ",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "SF UI Text",
                    fontWeight: FontWeight.w600,
                    color: darkGrayColor,
                    height: 1.2),
              ),
            ),
            Expanded(
              child: Consumer<ConfigRepository>(builder: (context, repository, loadingState) {
                if (repository.isLoading) {
                  return Center(
                      child: SizedBox(
                    height: 32.0,
                    width: 32.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      backgroundColor: accentColor,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ));
                }

                if (repository.isLoaded) {
                  final config = repository.response?.content;

                  return Column(
                    children: [
                      Tapable(
                        padding: EdgeInsets.all(10),
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => CitySelector(),
                          ));
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 6, bottom: 6, right: 10),
                          child: Row(
                            children: [
                              SVGIcon(
                                icon: IconAsset.location,
                                height: 30,
                                color: Colors.black,
                              ),
                              Text(
                                'Мой город',
                                style: textTheme.subtitle1,
                              ),
                              Spacer(),
                              Consumer<CitiesRepository>(
                                builder: (context, value, _) => Text(
                                  value.city?.name ?? "Город не выбран",
                                  style: textTheme.subtitle2,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ItemsDivider(),
                      Tapable(
                        padding: EdgeInsets.only(top: 14, bottom: 14),
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future: SharedPreferences.getInstance()
                                    .then((prefs) => prefs.getString(Prefs.user_phone)),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: textTheme.subtitle1,
                                    );
                                  }
                                  return SizedBox();
                                },
                              ),
                              Text(
                                'Телефон',
                                style: textTheme.subtitle2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ItemsDivider(),
                      Tapable(
                        padding: EdgeInsets.only(top: 14, bottom: 14),
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // FutureBuilder(
                              //   future: SharedPreferences.getInstance()
                              //       .then((prefs) => prefs.getString(Prefs.user_phone)),
                              //   builder: (context, snapshot) {
                              //     if (snapshot.hasData) {
                              //       return Text(
                              //         snapshot.data.toString(),
                              //         style: textTheme.subtitle1,
                              //       );
                              //     }
                              //     return SizedBox();
                              //   },
                              // ),
                              Text(
                                "test@test.test",
                                style: textTheme.subtitle1,
                              ),
                              Text(
                                'Телефон',
                                style: textTheme.subtitle2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ItemsDivider(),
                      Tapable(
                        padding: EdgeInsets.only(top: 14, bottom: 14),
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Мужской",
                                style: textTheme.subtitle1,
                              ),
                              Text(
                                'Пол',
                                style: textTheme.subtitle2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 14),
                        width: double.infinity,
                        color: Color(0xFFF2F2F2),
                      ),
                      Tapable(
                        padding: EdgeInsets.all(10),
                        onTap: () {
                          if (config?.userAgreementUrl != null)
                            widget.onDocPush(
                              config.userAgreementUrl,
                              "Соглашение",
                            );
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                'Пользовательское соглашение',
                                style: textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ItemsDivider(),
                      Tapable(
                        padding: EdgeInsets.all(10),
                        onTap: () {
                          if (config?.sellerOfertaIrl != null)
                            widget.onDocPush(
                              config.sellerOfertaIrl,
                              "Оферта",
                            );
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                'Оферта для продавцов',
                                style: textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 14),
                        width: double.infinity,
                        color: Color(0xFFF2F2F2),
                      ),
                      Tapable(
                        padding: EdgeInsets.all(10),
                        onTap: () {
                          Provider.of<LogoutRepository>(context, listen: false).logout();
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                'Выйти',
                                style: textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 14),
                        width: double.infinity,
                        color: Color(0xFFF2F2F2),
                      ),
                    ],
                  );
                } else
                  return loadingState;
              }),
            )
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    showDialog(
        context: context,
        builder: (dialogContext) {
          this.dialogContext = dialogContext;
          return CustomDialog.Dialog(
            dialogContent: [
              DialogItemContent(DialogItemType.item, title: "Сделать фото", onClick: () {
                return openCamera();
              }, icon: IconAsset.camera),
              DialogItemContent(DialogItemType.item, title: "Выбрать из галереи", onClick: () {
                return openGallery();
              }, icon: IconAsset.image),
              if (userPhoto != null)
                DialogItemContent(
                  DialogItemType.item,
                  title: "Удалить",
                  onClick: () async {
                    setState(() {
                      userPhoto = null;
                    });
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

  Future openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        userPhoto = pickedFile.path;
      });
      SharedPreferences.getInstance().then((prefs) async {
        await prefs.setString(Prefs.user_photo, pickedFile.path);
      });
      Navigator.pop(dialogContext);
    }
  }

  Future openCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        userPhoto = pickedFile.path;
      });
      SharedPreferences.getInstance().then((prefs) async {
        await prefs.setString(Prefs.user_photo, pickedFile.path);
      });
      Navigator.pop(dialogContext);
    }
  }

  Widget _appBar(context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).padding.top + 90,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Tapable(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            onTap: () {
              getImage();
            },
            child: Row(
              children: [
                Container(
                    width: 50,
                    height: 50,
                    child: FutureBuilder(
                        future: SharedPreferences.getInstance()
                            .then((prefs) => prefs.getString(Prefs.user_photo)),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.file(
                                  File(snapshot.data),
                                  fit: BoxFit.cover,
                                ));
                          }
                          return Image.asset('assets/icons/png/user_placeholder_grey.png');
                        })),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder(
                        future: SharedPreferences.getInstance()
                            .then((prefs) => prefs.getString(Prefs.user_name)),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data.toString(),
                              style: textTheme.subtitle1,
                            );
                          }
                          return SizedBox();
                        },
                      ),
                      Text(
                        'ФИО',
                        style: textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SVGIcon(
                  icon: IconAsset.next,
                  height: 12,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
