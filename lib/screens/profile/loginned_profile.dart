import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';
import 'package:refashioned_app/services/api_service.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizedProfilePage extends StatelessWidget {
  final Function() onFavClick;
  final Function() onSettingsClick;

  const AuthorizedProfilePage({Key key, this.onFavClick, this.onSettingsClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _appBar(context),
          _menuButtons(context),
          _profileBody(context),
        ],
      ),
    );
  }

  Widget _appBar(context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Color(0xFF373A3F),
        height: MediaQuery.of(context).size.height * 0.24,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Tapable(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            onTap: () {},
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  child: Image.asset('assets/user_placeholder.png'),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder(
                        future: SharedPreferences.getInstance().then((prefs) => prefs.getString(Prefs.user_name)),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            );
                          }
                          return SizedBox();
                        },
                      ),
                      Text(
                        'Мой профиль',
                        style: textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SVGIcon(
                  icon: IconAsset.next,
                  height: 20,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButtons(context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tapable(
                  onTap: () {},
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SVGIcon(
                        icon: IconAsset.box,
                        height: 35,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7), child: Text('Мои заказы', style: textTheme.bodyText1)),
                    ],
                  ),
                ),
                Tapable(
                  onTap: () {
                    onFavClick();
                  },
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SVGIcon(
                        icon: IconAsset.favoriteBorder,
                        height: 35,
                        color: Colors.black,
                      ),
                      Container(padding: EdgeInsets.only(top: 7), child: Text('Избранное', style: textTheme.bodyText1)),
                    ],
                  ),
                ),
                Tapable(
                  padding: EdgeInsets.all(10),
                  onTap: () {},
                  child: Column(
                    children: [
                      SVGIcon(
                        icon: IconAsset.notifications,
                        height: 35,
                        color: Colors.black,
                      ),
                      Container(padding: EdgeInsets.only(top: 7), child: Text('Подписки', style: textTheme.bodyText1)),
                    ],
                  ),
                ),
                Tapable(
                  padding: EdgeInsets.all(10),
                  onTap: () {
                    onSettingsClick();
                  },
                  child: Column(
                    children: [
                      SVGIcon(
                        icon: IconAsset.settings,
                        height: 35,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text(
                            'Настройки',
                            style: textTheme.bodyText1,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _profileBody(context) {
    ApiService.getCategories();
    List<Category> categories;
    print('123123#!#! $categories');
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            SVGIcon(
              icon: IconAsset.hanger,
              height: 70,
              color: Colors.black,
            ),
            Text(
              'Ваш гардероб пуст',
              style: textTheme.headline1,
            ),
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'Вы еще не разместили ни одной вещи \n в вашем гардеробе',
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: Button(
                "РАЗМЕСТИТЬ ВЕЩЬ",
                buttonStyle: ButtonStyle.dark,
                height: 45,
                width: 180,
                borderRadius: 5,
                onClick: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => MarketplaceNavigator(
                        onClose: Navigator.of(context).pop,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}