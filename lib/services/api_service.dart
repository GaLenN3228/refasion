import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refashioned_app/services/dio_client.dart';
import 'package:cookie_jar/cookie_jar.dart';

import '../utils/url.dart';

class ApiService {
  static const LOG_ENABLE = false;

  static Map<String, String> header = {"Content-Type": "application/json"};

  static Future<Response> getCategories() async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.categories);
  }

  static Future<Response> getProducts({String parameters}) async {
    DioClient dioClient = DioClient();
    return dioClient
        .getClient(logging: LOG_ENABLE)
        .get(Url.products + (parameters ?? ''));
  }

  static Future<Response> getSearchResults(String query) async {
    DioClient dioClient = DioClient();
    return dioClient
        .getClient(logging: LOG_ENABLE)
        .get(Url.catalogSearch + query);
  }

  static Future<Response> getProduct(String id) async {
    return DioClient()
        .getClient(logging: LOG_ENABLE)
        .get(Url.products + id + "/");
  }

  static Future<Response> getCart() async {
    Dio dio = DioClient().getClient(logging: LOG_ENABLE);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(dir: "$appDocPath/.cookies/");
    dio.interceptors.add(CookieManager(cookieJar));
    return dio.get(Url.cart);
  }

  static Future<Response> getContentCatalogMenu() async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.catalogMenu);
  }

  static Future<Response> getProductsCount({String parameters}) async {
    DioClient dioClient = DioClient();
    return dioClient
        .getClient(logging: LOG_ENABLE)
        .get(Url.productsCount + (parameters ?? ''));
  }

  static Future<Response> getSellProperties() async =>
      await DioClient().getClient(logging: LOG_ENABLE).get(Url.properties);

  static Future<Response> getSellPropertyValues(String id) async =>
      await DioClient().getClient(logging: LOG_ENABLE).get(Url.properties + id);

  static Future<Response> getFilters() async =>
      await DioClient().getClient(logging: LOG_ENABLE).get(Url.filters);

  static Future<Response> getSortMethods() async =>
      await DioClient().getClient(logging: LOG_ENABLE).get(Url.sortMethods);

  static Future<Response> getCities() async =>
      await DioClient().getClient(logging: LOG_ENABLE).get(Url.getCities);

  static Future<Response> getGeolocation() async =>
      await DioClient().getClient(logging: LOG_ENABLE).get(Url.getGeolocation);

  static Future<Response> selectCity(String city) async {
    final dio = DioClient().getClient(logging: LOG_ENABLE);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(dir: "$appDocPath/.cookies/");
    dio.interceptors.add(CookieManager(cookieJar));

    return await dio.post(Url.selectCity, data: city);
  }

  static Future<Response> search(String query) async {
    DioClient dioClient = DioClient();
    var queryParameters = {
      'q': query,
    };
    return dioClient
        .getClient(logging: LOG_ENABLE)
        .get(Url.search, queryParameters: queryParameters);
  }

  static addToCart(String productId) async {
    Dio dio = DioClient().getClient(logging: LOG_ENABLE);

    var body = {"product": productId};

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(dir: "$appDocPath/.cookies/");
    dio.interceptors.add(CookieManager(cookieJar));

    await dio.post(Url.cartItem, data: body);
  }

  static Future<Response> getQuickFilters() async =>
      await DioClient().getClient(logging: LOG_ENABLE).get(Url.quick_filters);
}
