import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String initialUrl;
  final String finishUrl;
  final Function() onFinish;
  final String title;
  final bool includeBottomPadding;

  const WebViewPage({
    Key key,
    this.initialUrl,
    this.onFinish,
    this.finishUrl,
    this.title,
    this.includeBottomPadding: false,
  }) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
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
              middleText: widget.title,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: stackIndex,
              children: [
                Center(
                  child: CupertinoActivityIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, bottom: widget.includeBottomPadding ? MediaQuery.of(context).padding.bottom : 0),
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
                      if (widget.finishUrl != null && request.url.startsWith(widget.finishUrl)) {
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
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer(),
                      ),
                    },
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
