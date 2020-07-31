import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:refashioned_app/screens/components/button.dart';

class CodePage extends StatefulWidget {
  final String phone;

  const CodePage({Key key, this.phone}) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> with WidgetsBindingObserver {
  Timer _timer;
  int _start = 59;

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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  textControllerListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Введите код из из SMS",
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
              )),
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
              pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  fieldHeight: 50,
                  fieldWidth: 40,
                  selectedColor: Colors.black,
                  activeColor: Color(0xFFFAD24E),
                  inactiveColor: Color(0xFFFAD24E)),
              animationDuration: Duration(milliseconds: 300),
              enableActiveFill: false,
//            errorAnimationController: errorController,
//            controller: textEditingController,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                print(value);
                setState(() {
//                currentText = value;
                });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            ),
          )
        ],
      ),
      Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        alignment: Alignment.bottomCenter,
        child: Button(
          _start == 0 ? "ПОЛУЧИТЬ НОВЫЙ" : "ПОЛУЧИТЬ НОВЫЙ ЧЕРЕЗ 0:$_start",
//          buttonStyle: phoneIsEmpty ? ButtonStyle.dark_gray : ButtonStyle.dark,
          buttonStyle: _start == 0 ? ButtonStyle.dark : ButtonStyle.dark_gray,
          height: 45,
          width: double.infinity,
          borderRadius: 5,
          onClick: () {},
        ),
      )
    ]));
  }
}
