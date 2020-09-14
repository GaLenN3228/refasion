import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NamePage extends StatefulWidget {
  const NamePage({Key key}) : super(key: key);

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<NamePage> with WidgetsBindingObserver {
  TextEditingController textEditingController;
  String name;

  @override
  void initState() {
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
      name = textEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
            child: Container(
                padding: const EdgeInsets.only(right: 16.0, top: 60),
                alignment: Alignment.topRight,
                child: Text(
                  "Закрыть",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(color: Color(0xFF959595)),
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Как вас зовут?",
                  style: textTheme.headline1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 28.0, left: 20, right: 20),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: textEditingController,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20),
                  cursorWidth: 2.0,
                  cursorRadius: Radius.circular(2.0),
                  cursorColor: Color(0xFFE6E6E6),
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                      hintText: "Введите имя",
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20)),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            alignment: Alignment.bottomCenter,
            child: Button(
              "ЗАВЕРШИТЬ",
              buttonStyle: name != null && name.length == 0 ? ButtonStyle.dark_gray : ButtonStyle.dark,
              height: 45,
              width: double.infinity,
              borderRadius: 5,
              onClick: name != null && name.length > 0
                  ? () {
                      SharedPreferences.getInstance().then((prefs) => prefs.setString(Prefs.user_name, name));
                      Navigator.pop(context);
                    }
                  : () {},
            ),
          )
        ]));
  }
}
