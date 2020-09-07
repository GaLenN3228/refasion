import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/maps/components/map.dart';
import 'package:refashioned_app/screens/maps/controllers/map_bottom_sheet_data_controller.dart';
import 'package:refashioned_app/screens/maps/controllers/map_data_controller.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';

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
               padding: const EdgeInsets.only(top: 55, left: 20, right: 20),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Tapable(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: SVGIcon(
                            icon: IconAsset.back,
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


class SettingForAuthUser extends StatefulWidget {
  @override
  _SettingForAuthUserState createState() => _SettingForAuthUserState();
}

class _SettingForAuthUserState extends State<SettingForAuthUser> {
  MapBottomSheetDataController mapBottomSheetDataController;
  MapDataController mapDataController;
  @override
  void initState() {
    mapDataController = MapDataController(
        pickUpPointsCompany: PickUpPointsCompany.BOXBERRY
    );
    mapBottomSheetDataController = MapBottomSheetDataController(
        mapBottomSheetDataPreview: MapBottomSheetData(
            title: "Где можно забрать вещь?",
            hint: "Укажите на карте или введите адрес вручную"),
        mapBottomSheetDataAddress: MapBottomSheetData(
          isCancelPointEnable: true,
          title: "Адрес доставки",
        )
    );

    super.initState();
  }
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
                      child: SVGIcon(
                        icon:  IconAsset.back,
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
                padding: EdgeInsets.only(top: 20, left: 10, bottom: 10, right: 10),
                child: Row(
                  children: [
                    SVGIcon(
                      icon: IconAsset.location,
                      height: 30,
                      color: Colors.black,
                    ),
                    Text('Мой город', style: textTheme.subtitle1,),
                    Spacer(),
                    Text(
                      'Москва',
                      style: textTheme.subtitle2,
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
              onTap: (){
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => MapsPickerPage(
                    mapDataController: mapDataController,
                    mapBottomSheetDataController: mapBottomSheetDataController,
                  )
                ));
              },
              child: Container(
                padding: EdgeInsets.only(top: 15, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text('Пункты выдачи', style: textTheme.subtitle1,),
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

