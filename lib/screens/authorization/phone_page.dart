import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/authorization.dart';
import 'package:refashioned_app/screens/authorization/code_page.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class PhonePage extends StatefulWidget {
  final Function(BuildContext) onAuthorizationCancel;
  final Function(BuildContext) onAuthorizationDone;
  final bool needDismiss;

  const PhonePage({Key key, this.onAuthorizationCancel, this.onAuthorizationDone, this.needDismiss = true})
      : super(key: key);

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> with WidgetsBindingObserver {
  TextEditingController textEditingController;
  bool phoneIsEmpty;
  String phone;
  MaskTextInputFormatter maskFormatter;

  @override
  void initState() {
    phoneIsEmpty = false;
    textEditingController = TextEditingController();
    maskFormatter = new MaskTextInputFormatter(mask: '### ### ## ##', filter: {"#": RegExp(r'[0-9]')});
    textEditingController.addListener(textControllerListener);

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
      phoneIsEmpty = textEditingController.text.isEmpty;
      phone = "+7 " + textEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

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
                      widget.onAuthorizationCancel?.call(context);
                      if (widget.needDismiss) if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        SystemNavigator.pop();
                      }
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("+7 ", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20)),
                    IntrinsicWidth(
                      child: TextField(
                        inputFormatters: [maskFormatter],
                        textAlign: TextAlign.start,
                        controller: textEditingController,
                        keyboardType: TextInputType.phone,
                        autofocus: true,
                        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20),
                        cursorWidth: 2.0,
                        cursorRadius: Radius.circular(2.0),
                        cursorColor: Color(0xFFE6E6E6),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "Введите номер",
                            hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Color(0xFFFAD24E),
                  width: double.infinity,
                  height: 2,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 28.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Нажмите кнопку «Получить код», вы соглашаететсь\nс условиями ",
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
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  alignment: Alignment.bottomCenter,
                  child: Button(
                    "ПОЛУЧИТЬ КОД",
                    buttonStyle: phoneIsEmpty || (phone != null && phone.length < 16)
                        ? CustomButtonStyle.dark_gray
                        : CustomButtonStyle.dark,
                    height: 45,
                    width: double.infinity,
                    borderRadius: 5,
                    onClick: !phoneIsEmpty && phone != null && phone.length == 16
                        ? () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider<AuthorizationRepository>(
                                      create: (_) => AuthorizationRepository()
                                        ..sendPhoneAndGetCode(phone.replaceAll("+", "").replaceAll(" ", "")),
                                      child: CodePage(
                                        needDismiss: widget.needDismiss,
                                        phone: phone,
                                        onAuthorizationCancel: widget.onAuthorizationCancel,
                                        onAuthorizationDone: widget.onAuthorizationDone,
                                      ),
                                    )));
                          }
                        : () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
