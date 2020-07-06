import 'package:dio/dio.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/products_count.dart';

import '../services/api_service.dart';
import 'base.dart';

class CatalogRepository extends BaseRepository {
  CategoryResponse catalogResponse;
  ProductsCountResponse productsCountResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response catalogResponse = await ApiService.getCategories();
      final Response productsCountResponse = await ApiService.getProductsCount();

      this.catalogResponse = CategoryResponse.fromJson(catalogResponse.data);
      this.productsCountResponse = ProductsCountResponse.fromJson(productsCountResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
