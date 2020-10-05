import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String initialUrl;
  final Function() onFinish;

  const PaymentPage({Key key, this.initialUrl, this.onFinish}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Completer<WebViewController> controller = Completer<WebViewController>();

  num stackIndex = 0;

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) => JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        print("Message received: ${message.message}");

        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      });

  void handleLoadStart() {
    setState(() {
      stackIndex = 0;
    });
  }

  void handleLoadFinish() {
    setState(() {
      stackIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: white,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.simple(
                includeTopScreenPadding: false,
                middleText: "Оплата",
                onClose: () {
                  widget.onFinish?.call();

                  Navigator.of(context).pop();
                }),
          ),
          Expanded(
            child: IndexedStack(
              index: stackIndex,
              children: [
                Center(
                  child: CupertinoActivityIndicator(
                    animating: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: MediaQuery.of(context).padding.bottom),
                  child: WebView(
                    initialUrl: widget.initialUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      controller.complete(webViewController);
                    },
                    javascriptChannels: <JavascriptChannel>[
                      _toasterJavascriptChannel(context),
                    ].toSet(),
                    navigationDelegate: (NavigationRequest request) async {
                      if (request.url.startsWith('https://refashioned.ru/')) {
                        print('blocking navigation to $request}');

                        Navigator.of(context).pop();

                        await widget.onFinish?.call();

                        return NavigationDecision.prevent;
                      }

                      print('allowing navigation to $request');

                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (url) => handleLoadStart(),
                    onPageFinished: (url) => handleLoadFinish(),
                    gestureNavigationEnabled: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
