import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/authorization/phone_page.dart';
import 'package:refashioned_app/screens/components/button.dart';

class ProfilePage extends StatelessWidget {
  final Function(List<String>) onPush;

  const ProfilePage({Key key, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(
              child: Stack(children: [
            Expanded(
              child: Container(
                color: Colors.grey,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Container(
                  color: Colors.white,
                  height: 280,
                  child: Column(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 13,
                        ),
                        Container(
                          width: 30,
                          height: 3,
                          decoration: ShapeDecoration(
                              color: Colors.black.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100))),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(top: 14.0, left: 20),
                      child: Text(
                        "Давайте знакомиться!",
                        style: textTheme.subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(top: 10.0, left: 20),
                      child: Text(
                        "Получайте персональные предложения, дарим подарок на день рождения, сохраним адрес доставки и расскажем об акциях",
                        style: textTheme.caption,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Button(
                        "ВОЙТИ ПО НОМЕРУ ТЕЛЕФОНА",
                        buttonStyle: ButtonStyle.dark,
                        height: 45,
                        width: double.infinity,
                        borderRadius: 5,
                        onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PhonePage()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 40),
                      child: Button(
                        "ВОЙТИ ЧЕРЕЗ СБЕРБАНК ID",
                        buttonStyle: ButtonStyle.outline,
                        height: 45,
                        width: double.infinity,
                        borderRadius: 5,
                      ),
                    )
                  ]),
                ),
              ),
            )
          ]))
        ],
      ),
    );
  }
}
