import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';



class AuthorizedProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      child: Column(
        children: [
            _appBar(context),
            _menuButtons(context),
            _profileBody(context),
        ],
      ),
    );
  }


  Widget _appBar(context){
    TextTheme textTheme = Theme.of(context).textTheme;
    return  Material(
      color: Colors.transparent,
      child: Container(
        color: Color(0xFF373A3F),
        height: MediaQuery.of(context).size.height * 0.26,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Tapable(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            onTap: (){

            },
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
                      Text(
                        'Валерия',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        'Мой профиль',
                        style: textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SvgPicture.asset(
                  'assets/arrow_right.svg',
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

  Widget _menuButtons(context){
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
                   onTap: (){},
                   padding: EdgeInsets.all(10),
                   child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/box.svg',
                          height: 25,
                          color: Colors.black,
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 7),
                            child: Text('Мои заказы', style: textTheme.bodyText1)),
                      ],
                    ),
                 ),
                Tapable(
                  onTap: (){},
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/favorite.svg',
                        height: 25,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text('Избранные', style: textTheme.bodyText1)),
                    ],
                  ),
                ),
                Tapable(
                  padding: EdgeInsets.all(10),
                  onTap: (){},
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/bell.svg',
                        height: 25,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text('Подписки', style: textTheme.bodyText1)),
                    ],
                  ),
                ),
                Tapable(
                  padding: EdgeInsets.all(10),
                  onTap: (){},
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/settings.svg',
                        height: 25,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text('Настройки', style: textTheme.bodyText1,)),
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

  Widget _profileBody(context){
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.white,
      child:  Column(
          children: [
            SvgPicture.asset(
              'assets/topbar/svg/hanger_44dp.svg',
              height: 70,
              color: Colors.black,
            ),
            Text('Ваш гардероб пуст', style: textTheme.headline1,),
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text('Вы еще не разместили ни одной вещи \n в вашем гардеробе', textAlign: TextAlign.center,)),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Button(
                "РАЗМЕСТИТЬ ВЕЩЬ",
                buttonStyle: ButtonStyle.dark,
                height: 45,
                width: 180,
                borderRadius: 5,
                onClick: () {
                },
              ),
            ),
          ],
        ),

    );
  }
}
