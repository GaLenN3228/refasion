import 'package:dio/dio.dart';
import 'package:refashioned_app/services/dio_client.dart';

import '../utils/url.dart';

class ApiService {
  static const LOG_ENABLE = true;

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
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.cart);
  }

  static Future<Response> getContentCatalogMenu() async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.catalogMenu);
  }

  static Future<Response> getProductsCount({String parameters}) async {
    DioClient dioClient = DioClient();
    return dioClient
        .getClient(logging: true)
        .get(Url.productsCount + (parameters ?? ''));
  }

  static Future<Response> getFilters() async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.filters);
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
}
