import 'package:dio/dio.dart';
import 'package:refashioned_app/services/api/dio_client.dart';
import 'package:refashioned_app/utils/url.dart';

class ApiService {
  //FIXME set LOG_ENABLE = false in release build
  static const LOG_ENABLE = true;

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
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.get(Url.cart);
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
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.post(Url.selectCity, data: city);
  }

  static Future<Response> search(String query) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    var queryParameters = {
      'q': query,
    };
    return dioClient.get(Url.search, queryParameters: queryParameters);
  }

  static Future<Response> addToCart(String productId) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"product": productId};
    return dioClient.post(Url.cartItem, data: body);
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

  static Future<Response> sendPhone(String phone) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    var body = {"phone": phone};
    return dioClient.post(Url.authorization, data: body);
  }

  static Future<Response> sendCode(String phone, String hash, String code) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"code": code};
    return dioClient.post(Url.codeAuthorization(phone, hash), data: body);
  }

  static Future<Response> getFavourites() async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.get(Url.wished);
  }

  static Future<Response> addToFavourites(String productId) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"product": productId};
    return dioClient.post(Url.wished, data: body);
  }

  static Future<Response> removeFromFavourites(String productId) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"product": productId};
    return dioClient.delete(Url.wished, data: body);
  }
}
