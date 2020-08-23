import 'package:refashioned_app/services/api/dio_cookies_manager.dart';

class LocalService {
  static Future<String> getCartCountFromCookies(Uri responseUri) async {
    return await DioCookiesManager().getValue(CookiesValues.cartCount, responseUri);
  }
}