import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/screens/authorization/phone_page.dart';
import 'package:refashioned_app/screens/city_selector/city_selector.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Function() onSettingsClick;
  final Function() onMapPageClick;

  const ProfilePage({
    Key key,
    this.onSettingsClick,
    this.onMapPageClick,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
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
                    child: Image.asset('assets/icons/png/user_placeholder_yellow.png'),
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
                      buttonStyle: CustomButtonStyle.dark,
                      height: 45,
                      width: double.infinity,
                      borderRadius: 5,
                      onClick: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => KeyboardVisibilityProvider(
                              child: PhonePage(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Consumer<CitiesRepository>(
                      builder: (context, value, _) => ProfileItem(
                            icon: IconAsset.location,
                            title: 'Мой город',
                            city: value.city?.name ?? "Город не выбран",
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => CitySelector(),
                              ));
                            },
                          )),
                  ProfileItem(
                    icon: null,
                    title: 'Пункты выдачи',
                    city: '',
                    onTap: () {
                      widget.onMapPageClick();
                    },
                  ),
                  ProfileItem(
                    icon: null,
                    title: 'Настройки',
                    city: '',
                    onTap: () {
                      widget.onSettingsClick();
                    },
                  ),
                ],
              ),
            );
          },
        ));
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final IconAsset icon;
  final String city;
  final Function() onTap;

  const ProfileItem({Key key, this.title, this.icon, this.city, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Tapable(
      onTap: () {
        onTap();
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
