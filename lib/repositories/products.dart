import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/product_price.dart';
import 'package:refashioned_app/models/products.dart';
import 'package:refashioned_app/models/property.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';

import '../services/api_service.dart';
import 'base.dart';

class ProductsRepository extends BaseRepository<ProductsContent> {
  Future<void> getProducts(String parameters) => apiCall(() async {
        response = BaseResponse.fromJson(
            (await ApiService.getProducts(parameters: parameters)).data,
            (contentJson) => ProductsContent.fromJson(contentJson));
        await BaseRepository.isAuthorized().then((isAuthorized) async {
          if (isAuthorized) {
            FavouritesRepository favouritesRepository = FavouritesRepository();
            await favouritesRepository.getFavourites();

            response.content.products.forEach((product) {
              if (favouritesRepository.response.content
                  .any((favourite) => favourite.productId == product.id))
                product.isFavourite = true;
              else
                product.isFavourite = false;
            });
          }
        });
      });
}

class ProductRepository extends BaseRepository<Product> {
  Future<void> getProduct(String id) => apiCall(() async {
        response = BaseResponse.fromJson(
            (await ApiService.getProduct(id)).data, (contentJson) => Product.fromJson(contentJson));

        combineProductProperties();

        await BaseRepository.isAuthorized().then((isAuthorized) async {
          if (isAuthorized) {
            FavouritesRepository favouritesRepository = FavouritesRepository();
            await favouritesRepository.getFavourites();

            if (favouritesRepository.response.content
                .any((favourite) => favourite.productId == response.content.id))
              response.content.isFavourite = true;
            else
              response.content.isFavourite = false;
          }
        });
      });

  void combineProductProperties() {
    if (response != null && response.content != null && response.content.properties != null) {
      var finalProperties = Map<String, Property>();

      response.content.properties.forEach((property) {
        finalProperties.update(property.property, (value) => value..value += ", " + property.value,
            ifAbsent: () => finalProperties.putIfAbsent(property.property, () => property));
      });

      response.content.properties = finalProperties.values.toList();
    }
  }
}

class ProductRecommendedRepository extends BaseRepository<List<Product>> {
  Future<void> getProductRecommended(String id) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getProductRecommended(id)).data,
            (contentJson) => [for (final product in contentJson) Product.fromJson(product)]);

        await BaseRepository.isAuthorized().then((isAuthorized) async {
          if (isAuthorized) {
            FavouritesRepository favouritesRepository = FavouritesRepository();
            await favouritesRepository.getFavourites();

            response.content.forEach((product) {
              if (favouritesRepository.response.content
                  .any((favourite) => favourite.productId == product.id))
                product.isFavourite = true;
              else
                product.isFavourite = false;
            });
          }
        });
      });
}

class CalcProductPrice extends BaseRepository<ProductPrice> {
  Future<void> calcProductPrice(int price) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.calcProductPrice(price)).data,
            (contentJson) => ProductPrice.fromJson(contentJson));
      });
}

class AddProductRepository extends BaseRepository {
  Future<void> addProduct(ProductData productData) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.addProducts(productData)).data, null);
      });
}

class ProfileProductsRepository extends BaseRepository<ProductsContent> {
  Future<void> getProducts() => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getProfileProducts()).data,
            (contentJson) => ProductsContent.fromJson(contentJson));
        await BaseRepository.isAuthorized().then((isAuthorized) async {
          if (isAuthorized) {
            FavouritesRepository favouritesRepository = FavouritesRepository();
            await favouritesRepository.getFavourites();

            response.content.products.forEach((product) {
              if (favouritesRepository.response.content
                  .any((favourite) => favourite.productId == product.id))
                product.isFavourite = true;
              else
                product.isFavourite = false;
            });
          }
        });
      });
}
