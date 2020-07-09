import 'package:dio/dio.dart';
import 'package:refashioned_app/services/dio_client.dart';

import '../utils/url.dart';

class ApiService {
  static Map<String, String> header = {"Content-Type": "application/json"};

  static Future<Response> getCategories() async {
    return DioClient().getClient(logging: true).get(Url.categories);
  }

  static Future<Response> getProducts(String id) async {
    DioClient dioClient = DioClient();
    var queryParameters = {
      'p': id,
    };
    return dioClient.getClient(logging: true).get(Url.products, queryParameters: queryParameters);
  }

  static Future<Response> getProduct(String id) async {
    return DioClient().getClient(logging: true).get(Url.products + id + "/");
  }

  static Future<Response> getContentCatalogMenu() async {
    return DioClient().getClient(logging: true).get(Url.catalogMenu);
  }

  static Future<Response> getProductsCount() async {
    return DioClient().getClient(logging: true).get(Url.productsCount);
  }

  static Future<Response> getFilters() async {
    return DioClient().getClient(logging: true).get(Url.filters);
  }
}
