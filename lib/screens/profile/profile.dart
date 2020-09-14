import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/screens/authorization/phone_page.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tab_switcher/components/bottom_tab_button.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:refashioned_app/screens/profile/loginned_profile.dart';
import 'package:refashioned_app/screens/profile/settings.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Function(List<String>) onPush;
  final CatalogNavigator catalogNavigator;
  final ValueNotifier<BottomTab> currentTab;

  ProfilePage({Key key, this.onPush, this.catalogNavigator, this.currentTab}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool checkAuth;

  @override
  void initState(){
    BaseRepository.isAuthorized().then((isAuthorized) {
      checkAuth = isAuthorized;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
        child: FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if(checkAuth != true){
          return Padding(
            padding: const EdgeInsets.only(top: 35.0, left: 20, right: 20),
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
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Button(
                    "ВОЙТИ ПО НОМЕРУ ТЕЛЕФОНА",
                    buttonStyle: ButtonStyle.dark,
                    height: 45,
                    width: double.infinity,
                    borderRadius: 5,
                    onClick: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => PhonePage()));
                    },
                  ),
                ),
                ProfileItem(
                  icon: IconAsset.location,
                  title: 'Мой город',
                  city: 'Москва',
                ),
                ProfileItem(
                  icon: null,
                  title: 'Пункты выдачи',
                  city: '',
                ),
                ProfileItem(
                  icon: null,
                  title: 'Настройки',
                  city: '',
                  route: SettingPage(),
                ),
              ],
            ),
          );
        }else{
          return AuthorizedProfilePage(catalogNavigator: widget.catalogNavigator, currentTab: widget.currentTab,);
        }
      },
    ));
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final IconAsset icon;
  final String city;
  final Widget route;

  const ProfileItem({Key key, this.title, this.icon, this.city, this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Tapable(
      onTap: () {
        route != null
            ? Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => route,
              ))
            : print('11');
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            child: Row(
              children: [
                icon != null
                    ? SVGIcon(
                        icon: icon,
                        height: 30,
                        color: primaryColor,
                      )
                    : Container(
                        width: 0,
                      ),
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      title,
                      style: textTheme.subtitle1,
                    )),
                Spacer(),
                city != ''
                    ? Text(
                        city,
                        style: textTheme.subtitle2,
                      )
                    : Container(),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
