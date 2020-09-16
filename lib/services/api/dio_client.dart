import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:refashioned_app/services/api/dio_cookies_manager.dart';

class DioClient {
  Dio _dioClient;

  DioClient() {
    _initDioClient();
  }

  void _initDioClient() {
    _dioClient = Dio();
  }

  Future<Dio> getClient({manageCookies = false, logging = false}) async {
    if (manageCookies) {
      PersistCookieJar persistCookieJar = await DioCookiesManager().getPersistCookieJar();
      _dioClient.interceptors.add(CookieManager(persistCookieJar));
    }

    if (logging)
      _dioClient.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 300));
    return _dioClient;
  }
}
