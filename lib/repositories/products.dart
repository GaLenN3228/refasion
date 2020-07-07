import 'package:dio/dio.dart';
import 'package:refashioned_app/models/products.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductsRepository extends BaseRepository {
  ProductsResponse productsResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response productResponse = await ApiService.getProducts();

      this.productsResponse = ProductsResponse.fromJson(productResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
