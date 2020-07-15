import 'package:dio/dio.dart';
import 'package:refashioned_app/services/dio_client.dart';

import '../utils/url.dart';

class ApiService {
  static const LOG_ENABLE = true;

  static Map<String, String> header = {"Content-Type": "application/json"};

  static Future<Response> getCategories() async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.categories);
  }

  static Future<Response> getProducts(String id, {int maxPrice, int minPrice}) async {
    DioClient dioClient = DioClient();
    var queryParameters = {
      'p': id,
      if (maxPrice != null) 'max_price': maxPrice,
      if (minPrice != null) 'min_price': minPrice
    };
    return dioClient.getClient(logging: LOG_ENABLE).get(Url.products, queryParameters: queryParameters);
  }

  static Future<Response> getSearchResults(String query) async {
    DioClient dioClient = DioClient();
    return dioClient.getClient(logging: LOG_ENABLE).get(Url.catalogSearch + query);
  }

  static Future<Response> getProduct(String id) async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.products + id + "/");
  }

  static Future<Response> getCart() async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.cart);
  }

  static Future<Response> getContentCatalogMenu() async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.catalogMenu);
  }

  static Future<Response> getProductsCount() async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.productsCount);
  }

  static Future<Response> getFilters() async {
    return DioClient().getClient(logging: LOG_ENABLE).get(Url.filters);
  }

  static Future<Response> search(String query) async {
    DioClient dioClient = DioClient();
    var queryParameters = {
      'q': query,
    };
    return dioClient.getClient(logging: LOG_ENABLE).get(Url.search, queryParameters: queryParameters);
  }
}
