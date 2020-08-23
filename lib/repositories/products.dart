import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/products.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductsRepository extends BaseRepository<ProductsContent> {
  Future<void> getProducts(String parameters) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getProducts(parameters: parameters)).data,
            (contentJson) => ProductsContent.fromJson(contentJson));
      });
}

class ProductRepository extends BaseRepository<Product> {
  Future<void> getProduct(String id) => apiCall(() async {
        response = BaseResponse.fromJson(
            (await ApiService.getProduct(id)).data, (contentJson) => Product.fromJson(contentJson));
      });
}

class ProductRecommendedRepository extends BaseRepository<List<Product>> {
  Future<void> getProductRecommended(String id) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getProductRecommended(id)).data,
            (contentJson) => [for (final product in contentJson) Product.fromJson(product)]);
      });
}
