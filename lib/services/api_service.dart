import 'package:dio/dio.dart';
import 'package:refashioned_app/services/dio_client.dart';
import 'package:refashioned_app/services/dio_cookies_manager.dart';
import 'dart:io' show Platform;

import '../utils/url.dart';


class ApiService {
  //FIXME set LOG_ENABLE = false in release build
  static bool LOG_ENABLE = (Platform.isAndroid) ? true : false;

  static Map<String, String> header = {"Content-Type": "application/json"};

  static Future<Response> getCategories() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.categories);
  }

  static Future<Response> getProducts({String parameters}) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.products + (parameters ?? ''));
  }

  static Future<Response> getSearchResults(String query) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.catalogSearch + query);
  }

  static Future<Response> getProduct(String id) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.products + id + "/");
  }

  static Future<Response> getCart() async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.get(Url.cart);
  }

  static Future<String> getCartCountFromCookies(Uri responseUri) async {
    return await DioCookiesManager()
        .getValue(CookiesValues.cartCount, responseUri);
  }

  static Future<Response> getContentCatalogMenu() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.catalogMenu);
  }

  static Future<Response> getProductsCount({String parameters}) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.productsCount + (parameters ?? ''));
  }

  static Future<Response> getSellProperties() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.properties);
  }

  static Future<Response> getSellPropertyValues(String id) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.properties + id);
  }

  static Future<Response> getFilters() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.filters);
  }

  static Future<Response> getSortMethods() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.sortMethods);
  }

  static Future<Response> getCities() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.getCities);
  }

  static Future<Response> getGeolocation() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.getGeolocation);
  }

  static Future<Response> selectCity(String city) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.post(Url.selectCity, data: city);
  }

  static Future<Response> search(String query) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    var queryParameters = {
      'q': query,
    };
    return dioClient.get(Url.search, queryParameters: queryParameters);
  }

  static addToCart(String productId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"product": productId};
    await dioClient.post(Url.cartItem, data: body);
  }

  static Future<Response> getQuickFilters() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.quick_filters);
  }

  static Future<Response> getProductRecommended(String id) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.productsRecommended(id));
  }

  static Future<Response> getPickPoints() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.pickPoints);
  }
}
