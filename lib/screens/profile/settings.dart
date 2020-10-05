import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/screens/city_selector/city_selector.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class SettingPage extends StatelessWidget {
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
                middleText: "Настройки",
              ),
            ),
            Tapable(
              padding: EdgeInsets.all(10),
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Условия использования',
                      style: textTheme.subtitle1,
                    ),
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
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Оферта на оказание услуг',
                      style: textTheme.subtitle1,
                    ),
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
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Лицензионное соглашение',
                      style: textTheme.subtitle1,
                    ),
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

class SettingForAuthUser extends StatefulWidget {
  final Function() onMapPageClick;

  const SettingForAuthUser({Key key, this.onMapPageClick}) : super(key: key);

  @override
  _SettingForAuthUserState createState() => _SettingForAuthUserState();
}

class _SettingForAuthUserState extends State<SettingForAuthUser> {
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
                middleText: "Настройки",
              ),
            ),
            Tapable(
              padding: EdgeInsets.all(10),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => CitySelector(),
                ));
              },
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 10, bottom: 10, right: 10),
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
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(),
            ),
            Tapable(
              padding: EdgeInsets.all(10),
              onTap: () {
                widget.onMapPageClick();
              },
              child: Container(
                padding: EdgeInsets.only(top: 15, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Пункты выдачи',
                      style: textTheme.subtitle1,
                    ),
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
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Условия использования',
                      style: textTheme.subtitle1,
                    ),
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
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Оферта на оказание услуг',
                      style: textTheme.subtitle1,
                    ),
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
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Лицензионное соглашение',
                      style: textTheme.subtitle1,
                    ),
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
