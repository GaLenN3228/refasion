import 'package:dio/dio.dart';
import 'package:refashioned_app/models/products_count.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductCountRepository extends BaseRepository {
  ProductsCountResponse productsCountResponse;

  String parameters;

  ProductCountRepository({this.parameters});

  update({String newParameters}) async {
    parameters = newParameters;
    await loadData();
  }

  @override
  Future<void> loadData() async {
    try {
      final Response productsCountResponse =
          await ApiService.getProductsCount(parameters: parameters);

      this.productsCountResponse =
          ProductsCountResponse.fromJson(productsCountResponse.data);

      finishLoading();
    } catch (err) {
      print("ProductCountRepository error:");
      print(err);
      receivedError();
    }
  }
}
