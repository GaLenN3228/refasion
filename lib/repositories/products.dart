import 'package:dio/dio.dart';
import 'package:refashioned_app/models/products.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductsRepository extends BaseRepository {
  ProductsResponse productsResponse;

  String parameters;

  ProductsRepository({this.parameters});

  update({String newParameters}) async {
    parameters = newParameters;
    await loadData();
  }

  @override
  Future<void> loadData() async {
    try {
      final Response productResponse =
          await ApiService.getProducts(parameters: parameters);

      this.productsResponse = ProductsResponse.fromJson(productResponse.data);

      finishLoading();
    } catch (err) {
      print("ProductsRepository error:");
      print(err);
      receivedError();
    }
  }
}
