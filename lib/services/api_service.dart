import 'package:dio/dio.dart';

import '../utils/url.dart';

class ApiService {
  static Future<Response> getCatalogCategories() async {
    return Dio().get(Url.catalogCategories);
  }

  static Future<Response> getCatalogProducts() async {
    return Dio().get(Url.catalogProducts);
  }

  static Future<Response> getCatalogProduct(String id) async {
    return Dio().get(Url.catalogProduct + id);
  }

  static Future<Response> getContentCatalogMenu() async {
    return Dio().get(Url.contentCatalogMenu);
  }
}
