import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';

enum CookiesValues { sessionId, cartCount }

class DioCookiesManager {
  static const CART_COUNT_COOKIE_NAME = "pic";

  Future<PersistCookieJar> getPersistCookieJar() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    return PersistCookieJar(dir: "$appDocPath/.cookies/");
  }

  Future<String> getValue(CookiesValues value, Uri responseUri) async {
    switch (value) {
      case CookiesValues.cartCount:
        PersistCookieJar persistCookieJar = await getPersistCookieJar();
        var cookies = persistCookieJar.loadForRequest(responseUri);
        return cookies.firstWhere((element) => element.name == CART_COUNT_COOKIE_NAME).value;

      case CookiesValues.sessionId:
        return "sessionId";

      default:
        print("Value not found");
        return null;
    }
  }
}
