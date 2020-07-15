import 'package:dio/dio.dart';
import 'package:refashioned_app/models/products.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductsRepository extends BaseRepository {
  ProductsResponse productsResponse;

  final String id;
  final int maxPrice;
  final int minPrice;

  ProductsRepository(this.id, {this.maxPrice, this.minPrice});

  @override
  Future<void> loadData() async {
    try {
      final Response productResponse = await ApiService.getProducts(id);

      this.productsResponse = ProductsResponse.fromJson(productResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
