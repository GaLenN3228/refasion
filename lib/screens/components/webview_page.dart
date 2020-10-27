import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum WebViewPageMode { fullScreen, modalSheet }

class WebViewPage extends StatefulWidget {
  final String initialUrl;
  final Map<String, Function()> onNewUrl;
  final String title;
  final bool includeBottomPadding;
  final bool includeTopPadding;
  final WebViewPageMode webViewPageMode;

  const WebViewPage({
    Key key,
    this.initialUrl,
    this.title,
    this.includeBottomPadding: false,
    this.onNewUrl,
    this.includeTopPadding,
    this.webViewPageMode: WebViewPageMode.fullScreen,
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
      backgroundColor: Colors.transparent,
      child: Container(
        color: white,
        margin: defaultTargetPlatform == TargetPlatform.iOS ? EdgeInsets.only(top: 0) : EdgeInsets.only(top: 80),
        child:Column(
        children: [
          widget.webViewPageMode == WebViewPageMode.fullScreen
              ? RefashionedTopBar(
                  data: TopBarData.simple(
                    onBack: Navigator.of(context).pop,
                    middleText: widget.title,
                    includeTopScreenPadding: widget.includeTopPadding ?? true,
                  ),
                )
              : RefashionedTopBar(
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
                      top: 10,
                      bottom:
                          widget.includeBottomPadding ? MediaQuery.of(context).padding.bottom : 0),
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
                      if (widget.onNewUrl != null) {
                        final entry = widget.onNewUrl.entries.firstWhere(
                            (element) => request.url.contains(element.key),
                            orElse: () => null);

                        if (entry != null) {
                          print('blocking navigation to ${request.url} because of ${entry.key}');

                          Navigator.of(context).pop();

                          await entry.value?.call();

                          return NavigationDecision.prevent;
                        }
                      }

                      print('allowing navigation to ${request.url}');

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
    )
    );
  }
}
