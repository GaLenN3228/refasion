import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String initialUrl;
  final Function(String) onUrlUpdate;

  const PaymentPage({Key key, this.initialUrl, this.onUrlUpdate}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Completer<WebViewController> controller = Completer<WebViewController>();

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
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
              onClose: Navigator.of(context).pop,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: MediaQuery.of(context).padding.bottom),
              child: WebView(
                initialUrl: widget.initialUrl, javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  controller.complete(webViewController);
                },
                // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                // ignore: prefer_collection_literals
                javascriptChannels: <JavascriptChannel>[
                  _toasterJavascriptChannel(context),
                ].toSet(),
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
