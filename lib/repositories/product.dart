import 'package:dio/dio.dart';
import 'package:refashioned_app/models/product.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductRepository extends BaseRepository {
  ProductResponse productResponse;

  final String id;

  ProductRepository(this.id);

  @override
  Future<void> loadData() async {
    try {
      final Response productResponse = await ApiService.getProduct(id);

      this.productResponse = ProductResponse.fromJson(productResponse.data);

      finishLoading();
    } catch (err) {
      print("ProductRepository error:");
      print(err);
      receivedError();
    }
  }
}
