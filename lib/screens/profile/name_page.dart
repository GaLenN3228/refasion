import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/authorization.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/repositories/config.dart';
import 'package:refashioned_app/screens/city_selector/city_selector.dart';
import 'package:refashioned_app/screens/components/button/simple_button.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog_item.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/components/textfield/ref_textfield.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/profile/components/user_name_controller.dart';
import 'package:refashioned_app/screens/profile/components/user_photo_controller.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog.dart' as CustomDialog;

class UserNamePage extends StatefulWidget {
  const UserNamePage({Key key}) : super(key: key);

  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  bool buttonEnabled = true;
  String userName;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RefashionedTopBar(
            data: TopBarData.simple(
              onBack: () => Navigator.of(context).pop(),
              middleText: "ИМЯ ПОЛЬЗОВАТЕЛЯ",
            ),
          ),
          FutureBuilder(
            future:
                SharedPreferences.getInstance().then((prefs) => prefs.getString(Prefs.user_name)),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (userName == null) userName = snapshot.data;
                return Padding(
                    padding: EdgeInsets.all(20),
                    child: RefashionedTextField(
                      text: snapshot.data,
                      autofocus: true,
                      hintText: "Введите имя",
                      keyboardType: TextInputType.text,
                      onSearchUpdate: (text) {
                        userName = text;
                        setState(() {
                          buttonEnabled = text.isNotEmpty;
                        });
                      },
                    ));
              }
              return SizedBox();
            },
          ),
        ]),
        Positioned(
          left: 0,
          right: 0,
          bottom: 70,
          child: SimpleButton(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            enabled: buttonEnabled,
            label: "Сохранить",
            onPush: () {
              SharedPreferences.getInstance().then((prefs) async {
                await prefs.setString(Prefs.user_name, userName);
                Provider.of<UserNameController>(context, listen: false).update();
                Navigator.of(context).pop();
              });
            },
          ),
        )
      ]),
    );
  }
}
