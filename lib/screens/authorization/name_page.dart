import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/customer.dart';
import 'package:refashioned_app/repositories/customer.dart';
import 'package:refashioned_app/screens/authorization/components/send_name_button.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/profile/components/user_name_controller.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NamePage extends StatefulWidget {
  final Function(BuildContext) onAuthorizationDone;
  final bool needDismiss;

  const NamePage({Key key, this.onAuthorizationDone, this.needDismiss}) : super(key: key);

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<NamePage> with WidgetsBindingObserver {
  TextEditingController textEditingController;
  bool keyboardVisible;
  bool updateButtonState;
  RBState buttonState;
  SetCustomerDataRepository setCustomerDataRepository;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    keyboardVisible = false;
    updateButtonState = false;
    buttonState = RBState.disabled;
    setCustomerDataRepository = SetCustomerDataRepository();
    textEditingController = TextEditingController();
    textEditingController.addListener(textControllerListener);

    SharedPreferences.getInstance().then((prefs) {
      sharedPreferences = prefs;

      if (sharedPreferences.containsKey(Prefs.user_name)) {
        var userName = sharedPreferences.getString(Prefs.user_name);
        textEditingController.text = userName;
        updateButtonState = true;
      }
    });

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final newKeyboardVisible = WidgetsBinding.instance.window.viewInsets.bottom > 0;

    if (keyboardVisible != newKeyboardVisible) setState(() => keyboardVisible = newKeyboardVisible);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textControllerListener);
    textEditingController.dispose();
    setCustomerDataRepository.dispose();

    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  textControllerListener() {
    if (updateButtonState)
      setState(() => buttonState = textEditingController.text.isNotEmpty ? RBState.enabled : RBState.disabled);
  }

  onPush() async {
    updateButtonState = false;

    setState(() => buttonState = RBState.loading);

    final customer = Customer(
      name: textEditingController.text ?? "Аноним",
      email: "customer_update_test@refashioned.ru",
    );
    final data = jsonEncode(customer.toJson());

    await Future.wait(
      [
        setCustomerDataRepository.update(data),
        Future.delayed(
          const Duration(milliseconds: 800),
        ),
      ],
    );

    final response = setCustomerDataRepository.response?.content;

    setState(() => buttonState = RBState.disabled);

    if (response != null) {
      if (sharedPreferences == null) sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(Prefs.user_name, textEditingController.text);

      widget.onAuthorizationDone?.call(context);

      Provider.of<UserNameController>(context, listen: false).update();

      if (widget.needDismiss) Navigator.pop(context);
    } else
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            "Ошибка",
            style: Theme.of(context).textTheme.headline1,
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              setCustomerDataRepository.response?.errors?.messages ?? "Неизвестная ошибка",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: Navigator.of(context).pop,
              child: Text("ОК"),
            )
          ],
        ),
      );

    updateButtonState = true;
  }

  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context).textTheme.headline1,
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
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFAD24E), width: 2)),
                        hintText: "Введите имя",
                        hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20)),
                  ),
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(bottom: keyboardVisible ? 20 : MediaQuery.of(context).padding.bottom + 65.0),
                alignment: Alignment.bottomCenter,
                child: SendCustomerNameButton(
                  state: buttonState,
                  onPush: onPush,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
