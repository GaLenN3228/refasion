import 'package:dio/dio.dart';
import '../services/api_service.dart';
import 'ProductRecommendedResponse.dart';
import 'base.dart';

class ProductRecommendedRepository extends BaseRepository {
  ProductsRecommendedResponse productsResponse;

  String id;

  ProductRecommendedRepository(this.id);

  @override
  Future<void> loadData() async {
    try {
      final Response productResponse =
      await ApiService.getProductRecommended(id);

      this.productsResponse = ProductsRecommendedResponse.fromJson(productResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}