import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/authorization/phone_page.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/webview_page.dart';

class AuthorizationSheet extends StatelessWidget {
  final Function(List<String>) onPush;
  final Function(BuildContext) onAuthorizationCancel;
  final Function(BuildContext) onAuthorizationDone;
  final bool needDismiss;

  const AuthorizationSheet(
      {Key key,
      this.onPush,
      this.onAuthorizationCancel,
      this.onAuthorizationDone,
      this.needDismiss = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
              color: Colors.white,
              height: 410,
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 14.0, left: 60, right: 60),
                  child: Text(
                    "Авторизируйтесь и получите доступ ко всем возможностям",
                    textAlign: TextAlign.center,
                    style: textTheme.headline2,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Image.asset(
                      'assets/images/png/authorization_sheet.png',
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Button(
                    "ВОЙТИ ПО НОМЕРУ ТЕЛЕФОНА",
                    buttonStyle: CustomButtonStyle.dark,
                    height: 45,
                    width: double.infinity,
                    borderRadius: 5,
                    onClick: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => PhonePage(
                                needDismiss: needDismiss,
                                onAuthorizationDone: onAuthorizationDone,
                                onAuthorizationCancel: onAuthorizationCancel,
                              )));
                    },
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
                          position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(animation),
                          child: WebViewPage(
                            initialUrl: "https://refashioned.ru/user-agreement",
                            title: "ПОЛЬЗОВАТЕЛЬСКОЕ СОГЛАШЕНИЕ",
                            webViewPageMode: WebViewPageMode.modalSheet,
                          )))),
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 16, left: 60, right: 60),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "При входе вы подтверждаете согласие с ",
                        style: textTheme.caption,
                        children: <TextSpan>[
                          TextSpan(
                            text: "условиями использования REFASHIONED",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.wavy,
                            ),
                          ),
                          TextSpan(
                            text: " и ",
                          ),
                          TextSpan(
                            text: "политикой о данных пользователей",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.wavy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
