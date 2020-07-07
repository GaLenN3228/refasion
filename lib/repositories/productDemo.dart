import 'package:dio/dio.dart';
import 'package:refashioned_app/models/product.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductRepositoryDemo extends BaseRepository {
  ProductResponse productResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response productResponse = await ApiService.getProduct("89e8bf1f-dd00-446c-8bce-4a5e9a31586a");

      this.productResponse = ProductResponse.fromJson(productResponse.data);
      print(this.productResponse);
      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
