import 'package:dio/dio.dart';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/products_count.dart';

import '../services/api_service.dart';
import 'base.dart';

class CatalogRepository extends BaseRepository<List<Category>> {
  Future<void> getCatalog() => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getCategories()).data,
            (contentJson) => [for (final category in contentJson) Category.fromJson(category)]);
      });
}

class ProductsCountRepository extends BaseRepository<ProductsCount> {
  Future<void> getProductsCount(String newParameters) => apiCall(() async {
        response =
            BaseResponse.fromJson((await ApiService.getProductsCount(parameters: newParameters)).data, (contentJson) => ProductsCount.fromJson(contentJson));
      });
}
