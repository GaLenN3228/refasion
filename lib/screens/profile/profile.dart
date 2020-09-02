import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashioned_app/screens/authorization/phone_page.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final Function(List<String>) onPush;

  ProfilePage({Key key, this.onPush}) : super(key: key);
    String cityId = '';


//  _nameRetriever() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    cityId = prefs.getString('city_id') ?? '';
//  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 14.0, bottom: 14),
              child: Text(
                "ПРОФИЛЬ",
                style: textTheme.headline1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 80,
              height: 80,
              child: Image.asset('assets/user_placeholder.png'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 14.0),
              child: Text(
                "Войдите в профиль",
                style: textTheme.headline1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 14.0),
              child: Text(
                "Чтобы делать покупки, пользоваться скидками и отслеживать заказы.",
                style: textTheme.bodyText2,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,),
              child: Button(
                "ВОЙТИ ПО НОМЕРУ ТЕЛЕФОНА",
                buttonStyle: ButtonStyle.dark,
                height: 45,
                width: double.infinity,
                borderRadius: 5,
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhonePage()));
                },
              ),
            ),
            profileItem(
            'assets/position.svg', 'Мой город', 'Москва', context,
            ),
            profileItem(
              '', 'Пункты выдачи', '', context,
            ),
            profileItem(
              '', 'Настройки', '', context,
            ),
          ],
        ),
      ),
    );
  }

  Widget profileItem(String icon, String title, String city, context){
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 20),
          child: Row(
            children: [
              icon != '' ? SvgPicture.asset(
                icon,
                height: 20,
                color: primaryColor,
              ): Container(width: 0,),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(title, style: textTheme.bodyText1,)),
              Spacer(),
              city != '' ? Text(city, style: textTheme.bodyText2,): Container(),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
