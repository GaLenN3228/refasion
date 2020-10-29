import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/repositories/config.dart';
import 'package:refashioned_app/screens/city_selector/city_selector.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class SettingPage extends StatefulWidget {
  final Function(String, String) onDocPush;

  const SettingPage({Key key, this.onDocPush}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
            Expanded(
              child: Consumer<ConfigRepository>(
                builder: (context, repository, loadingState) {
                  if (repository.isLoaded) {
                    final config = repository.response?.content;

                    if (config == null)
                      return Center(
                        child: Text(
                          'Не удалось загрузить ссылки',
                          style: textTheme.subtitle1,
                        ),
                      );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            padding: EdgeInsets.only(top: 20, left: 10, bottom: 10),
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
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(),
                        ),
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
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(),
                        ),
                      ],
                    );
                  } else
                    return Center(
                      child: SizedBox(
                        height: 32.0,
                        width: 32.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: accentColor,
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingForAuthUser extends StatefulWidget {
  final Function(String, String) onDocPush;

  final Function() onMapPageClick;

  const SettingForAuthUser({Key key, this.onMapPageClick, this.onDocPush}) : super(key: key);

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
            Expanded(
              child: Consumer<ConfigRepository>(
                builder: (context, repository, _) {
                  if (repository.isLoaded) {
                    final config = repository.response?.content;

                    if (config == null)
                      return Center(
                        child: Text(
                          'Не удалось загрузить ссылки',
                          style: textTheme.subtitle1,
                        ),
                      );

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
                          onTap: () {
                            if (config?.userAgreementUrl != null)
                              widget.onDocPush(
                                config.userAgreementUrl,
                                "Соглашение",
                              );
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 20, left: 10, bottom: 10),
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
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(),
                        ),
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
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(),
                        ),
                      ],
                    );
                  } else
                    return Center(
                      child: SizedBox(
                        height: 32.0,
                        width: 32.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: accentColor,
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
