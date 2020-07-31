import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/screens/authorization/code_page.dart';
import 'package:refashioned_app/screens/components/button.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key key}) : super(key: key);

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> with WidgetsBindingObserver {
  TextEditingController textEditingController;
  bool phoneIsEmpty;
  String phone;

  @override
  void initState() {
    phoneIsEmpty = false;
    textEditingController = TextEditingController();
    textEditingController.addListener(textControllerListener);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textControllerListener);

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  textControllerListener() {
    setState(() {
      phoneIsEmpty = textEditingController.text.isEmpty;
      phone = textEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    return Scaffold(
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Введите номер телефона",
                  style: textTheme.headline1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Чтобы войти и зарегистрироваться\nв приложении",
                  textAlign: TextAlign.center,
                  style: textTheme.caption,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 28.0, left: 20, right: 20),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: textEditingController,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 20),
                  cursorWidth: 2.0,
                  cursorRadius: Radius.circular(2.0),
                  cursorColor: Color(0xFFE6E6E6),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 10),
                      border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                      hintText: "Введите номер",
                      hintStyle: Theme
                          .of(context)
                          .textTheme
                          .subtitle
                          .copyWith(fontSize: 20)),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 28.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Нажмите кнопку Получить код, вы соглашаететсь\nс условиями ",
                      style: textTheme.caption,
                      children: <TextSpan>[
                        TextSpan(
                          text: "Пользовательского соглашения",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.wavy,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            alignment: Alignment.bottomCenter,
            child: Button(
              "ПОЛУЧИТЬ КОД",
              buttonStyle: phoneIsEmpty ? ButtonStyle.dark_gray : ButtonStyle.dark,
              height: 45,
              width: double.infinity,
              borderRadius: 5,
              onClick: !phoneIsEmpty ? () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CodePage(phone: phone)));
              } : () {},
            ),
          )
        ]));
  }
}
