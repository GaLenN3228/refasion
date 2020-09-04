import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/screens/authorization/phone_page.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:refashioned_app/screens/profile/loginned_profile.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
               padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Tapable(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                            'assets/icons/svg/back.svg',
                          height: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text('НАСТРОЙКИ', style: textTheme.headline1,),
                    Container(),
                  ],
                ),
             ),
            Tapable(
              padding: EdgeInsets.all(10),
              onTap: (){
              },
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text('Условия использования', style: textTheme.subtitle1,),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(),
            ),
            Tapable(
              padding: EdgeInsets.all(10),
              onTap: (){
              },
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text('Оферта на оказание услуг', style: textTheme.subtitle1,),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(),
            ),
            Tapable(
              padding: EdgeInsets.all(10),
              onTap: (){
              },
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text('Лицензионное соглашение', style: textTheme.subtitle1,),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}


class SettingForAuthUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Tapable(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/svg/back.svg',
                        height: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text('НАСТРОЙКИ', style: textTheme.headline1,),
                  Container(),
                ],
              ),
            ),
            Tapable(
              padding: EdgeInsets.all(10),
              onTap: (){
              },
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text('Условия использования', style: textTheme.subtitle1,),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(),
            ),
            Tapable(
              padding: EdgeInsets.all(10),
              onTap: (){
              },
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text('Оферта на оказание услуг', style: textTheme.subtitle1,),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(),
            ),
            Tapable(
              padding: EdgeInsets.all(10),
              onTap: (){
              },
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text('Лицензионное соглашение', style: textTheme.subtitle1,),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

