import 'package:dio/dio.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/models/products.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductsRepository extends BaseRepository {
  ProductsResponse productsResponse;

  String id;
  int maxPrice;
  int minPrice;

  ProductsRepository({this.id, this.maxPrice, this.minPrice});

  @override
  Future<void> loadData() async {
    try {
      final Response productResponse = await ApiService.getProducts(id: id, maxPrice: maxPrice, minPrice: minPrice);

      this.productsResponse = ProductsResponse.fromJson(productResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }

  void filterAndUpdateProducts(List<Filter> filters) {
    id = null;
    maxPrice = null;
    minPrice = null;

    if (filters.isNotEmpty)
      filters.forEach((filter) {
        filter.values.forEach((value) {
          this.id = value.id;
        });
      });
  }
}
