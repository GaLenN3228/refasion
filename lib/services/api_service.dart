import 'package:dio/dio.dart';

import '../utils/url.dart';

class ApiService {
  static Map<String, String> header = {"Content-Type": "application/json"};

  static Future<Response> getCategories() async {
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    return dio.get(Url.categories);
  }

  static Future<Response> getProducts() async {
    return Dio().get(Url.products);
  }

  static Future<Response> getProduct(String id) async {
    return Dio().get(Url.products + id);
  }

  static Future<Response> getContentCatalogMenu() async {
    return Dio().get(Url.catalogMenu);
  }

  static Future<Response> getProductsCount() async {
    return Dio().get(Url.productsCount);
  }
}
