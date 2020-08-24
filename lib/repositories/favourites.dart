import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/favourite.dart';

import '../services/api_service.dart';
import 'base.dart';

class AddRemoveFavouriteRepository extends BaseRepository {
  Future<void> addToFavourites(String productId) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.addToFavourites(productId)).data, null);
      });

  Future<void> removeFromFavourites(String productId) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.removeFromFavourites(productId)).data, null);
      });
}

class FavouritesRepository extends BaseRepository<List<Favourite>> {
  Future<void> getFavourites() => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getFavourites()).data,
            (contentJson) => [for (final favourite in contentJson) Favourite.fromJson(favourite)]);
      });
}
