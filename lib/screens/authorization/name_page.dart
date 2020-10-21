import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/profile/components/user_name_controller.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NamePage extends StatefulWidget {
  final Function(BuildContext) onAuthorizationDone;
  final bool needDismiss;

  const NamePage({Key key, this.onAuthorizationDone, this.needDismiss})
      : super(key: key);

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

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(Prefs.user_name)) {
        var userName = prefs.getString(Prefs.user_name);
        textEditingController.text = userName;
        name = userName;
      }
    });

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textControllerListener);

    textEditingController.dispose();

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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topCenter,
                child: RefashionedTopBar(
                  data: TopBarData.simple(
                    onClose: () {
                      SharedPreferences.getInstance().then(
                        (prefs) async {
                          widget.onAuthorizationDone?.call(context);
                          if (widget.needDismiss) if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            SystemNavigator.pop();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Column(
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
                    textCapitalization: TextCapitalization.sentences,
                    cursorRadius: Radius.circular(2.0),
                    cursorColor: Color(0xFFE6E6E6),
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                        hintText: "Введите имя",
                        hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20)),
                  ),
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                alignment: Alignment.bottomCenter,
                child: Button(
                  "ЗАВЕРШИТЬ",
                  buttonStyle: name != null && name.length == 0
                      ? CustomButtonStyle.dark_gray
                      : CustomButtonStyle.dark,
                  height: 45,
                  width: double.infinity,
                  borderRadius: 5,
                  onClick: name != null && name.length > 0
                      ? () {
                          SharedPreferences.getInstance().then((prefs) async {
                            await prefs.setString(Prefs.user_name, name);
                            widget.onAuthorizationDone?.call(context);
                            Provider.of<UserNameController>(context, listen: false).update();
                            if (widget.needDismiss) Navigator.pop(context);
                          });
                        }
                      : () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
