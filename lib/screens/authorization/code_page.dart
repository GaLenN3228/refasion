import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:refashioned_app/repositories/authorization.dart';
import 'package:refashioned_app/screens/authorization/name_page.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class CodePage extends StatefulWidget {
  final String phone;
  final Function(BuildContext) onAuthorizationCancel;
  final Function(BuildContext) onAuthorizationDone;
  final bool needDismiss;
  final Function() onPush;

  const CodePage({
    Key key,
    this.phone,
    this.onAuthorizationCancel,
    this.onAuthorizationDone,
    this.needDismiss,
    this.onPush,
  }) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  Timer _timer;
  int _start = 59;
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CodeAuthorizationRepository codeAuthorizationRepository;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    startTimer();
    errorController = StreamController<ErrorAnimationType>();
    codeAuthorizationRepository = Provider.of<CodeAuthorizationRepository>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    errorController.close();
    codeAuthorizationRepository?.removeListener(codeAuthorizationHandler);

    super.dispose();
  }

  void codeAuthorizationHandler() {
    if (codeAuthorizationRepository.isLoaded || codeAuthorizationRepository.loadingFailed) {
      if (codeAuthorizationRepository.getStatusCode == 400) {
        errorController.add(ErrorAnimationType.shake);
        setState(() {
          hasError = true;
        });
      } else if (codeAuthorizationRepository.getStatusCode == 200 ||
          codeAuthorizationRepository.getStatusCode == 201) {
        if (widget.onPush != null)
          widget.onPush();
        else
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => KeyboardVisibilityProvider(
                  child: NamePage(
                needDismiss: widget.needDismiss,
                onAuthorizationDone: widget.onAuthorizationDone,
              )),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthorizationRepository authorizationRepository =
        context.watch<AuthorizationRepository>();
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
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
                  "Введите код из SMS",
                  style: textTheme.headline1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 16.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Код отправлен на ",
                    style: textTheme.caption,
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.phone,
                        style: textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 230,
                margin: const EdgeInsets.only(top: 28.0, left: 20, right: 20),
                alignment: Alignment.center,
                color: Colors.white,
                child: PinCodeTextField(
                  autoDisposeControllers: false,
                  autoFocus: true,
                  length: 4,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  textInputType: TextInputType.number,
                  textStyle: TextStyle(
                      color: hasError ? Colors.redAccent : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 50,
                      fieldWidth: 40,
                      selectedColor: hasError ? Colors.redAccent : Colors.black,
                      activeColor: hasError ? Colors.redAccent : Color(0xFFFAD24E),
                      inactiveColor: hasError ? Colors.redAccent : Color(0xFFFAD24E)),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: false,
                  errorAnimationController: errorController,
                  onCompleted: (v) {
                    if (authorizationRepository.isLoaded) {
                      codeAuthorizationRepository.addListener(codeAuthorizationHandler);
                      codeAuthorizationRepository.sendCode(authorizationRepository.getPhone,
                          authorizationRepository.response.content.hash, v);
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      hasError = false;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              hasError
                  ? Container(
                      height: 16,
                      alignment: Alignment.center,
                      child: Text(
                        "Некорректный код",
                        textAlign: TextAlign.center,
                        style: textTheme.caption.copyWith(color: Colors.redAccent),
                      ))
                  : Container(
                      height: 16,
                      alignment: Alignment.center,
                    ),
            ],
          ),
          if (codeAuthorizationRepository.isLoading)
            Container(
              margin: EdgeInsets.only(top: 40),
              height: 32.0,
              width: 32.0,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: accentColor,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                KeyboardVisibilityProvider.isKeyboardVisible(context)
                    ? 20
                    : MediaQuery.of(context).padding.bottom,
              ),
              alignment: Alignment.bottomCenter,
              child: Button(
                _start == 0 ? "ПОЛУЧИТЬ НОВЫЙ КОД" : "ПОЛУЧИТЬ НОВЫЙ КОД ЧЕРЕЗ 0:$_start",
//          buttonStyle: phoneIsEmpty ? CustomButtonStyle.dark_gray : CustomButtonStyle.dark,
                buttonStyle: _start == 0 ? CustomButtonStyle.dark : CustomButtonStyle.dark_gray,
                height: 45,
                width: double.infinity,
                borderRadius: 5,
                onClick: () {
                  if (_start == 0 && authorizationRepository.isLoaded) {
                    authorizationRepository.sendPhoneAndGetCode(authorizationRepository.getPhone);
                    _start = 59;
                    startTimer();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
