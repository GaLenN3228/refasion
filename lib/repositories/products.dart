import 'package:dio/dio.dart';
import 'package:refashioned_app/models/product.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductRepository extends BaseRepository {
  ProductResponse productResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response productResponse = await ApiService.getProducts();

      this.productResponse = ProductResponse.fromJson(productResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
