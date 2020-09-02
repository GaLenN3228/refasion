import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:refashioned_app/repositories/authorization.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:provider/provider.dart';

class CodePage extends StatefulWidget {
  final String phone;

  const CodePage({Key key, this.phone}) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> with WidgetsBindingObserver {
  Timer _timer;
  int _start = 59;
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
    super.initState();
    startTimer();
    errorController = StreamController<ErrorAnimationType>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthorizationRepository authorizationRepository =
        context.watch<AuthorizationRepository>();
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Color(0xFF959595)),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      activeColor:
                          hasError ? Colors.redAccent : Color(0xFFFAD24E),
                      inactiveColor:
                          hasError ? Colors.redAccent : Color(0xFFFAD24E)),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: false,
                  errorAnimationController: errorController,
                  onCompleted: (v) {
                    if (authorizationRepository.isLoaded) {
                      var codeAuthorizationRepository =
                          CodeAuthorizationRepository();
                      codeAuthorizationRepository.addListener(() {
                        if (codeAuthorizationRepository.getStatusCode == 400) {
                          errorController.add(ErrorAnimationType.shake);
                          setState(() {
                            hasError = true;
                          });
                        } else if (codeAuthorizationRepository.getStatusCode ==
                                200 ||
                            codeAuthorizationRepository.getStatusCode == 201) {
                          Navigator.of(context)
                              .popUntil(ModalRoute.withName("/authorization"));
                        }
                      });
                      codeAuthorizationRepository.sendCode(
                          authorizationRepository.getPhone,
                          authorizationRepository.response.content.hash,
                          v);
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
                        style:
                            textTheme.caption.copyWith(color: Colors.redAccent),
                      ))
                  : Container(
                      height: 16,
                      alignment: Alignment.center,
                    ),
            ],
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            alignment: Alignment.bottomCenter,
            child: Button(
              _start == 0 ? "ПОЛУЧИТЬ НОВЫЙ" : "ПОЛУЧИТЬ НОВЫЙ ЧЕРЕЗ 0:$_start",
//          buttonStyle: phoneIsEmpty ? ButtonStyle.dark_gray : ButtonStyle.dark,
              buttonStyle:
                  _start == 0 ? ButtonStyle.dark : ButtonStyle.dark_gray,
              height: 45,
              width: double.infinity,
              borderRadius: 5,
              onClick: () {
                if (_start == 0 && authorizationRepository.isLoaded) {
                  authorizationRepository
                      .sendPhoneAndGetCode(authorizationRepository.getPhone);
                  _start = 59;
                  startTimer();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
