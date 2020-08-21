
import '../services/api_service.dart';
import 'base.dart';

class FavouriteRepository extends BaseRepository {

  @override
  Future<void> loadData() async {}

  Future<void> getFavourites() async {
    try {
      await ApiService.getFavourites();

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }

  Future<void> addToFavourites(String productId) async {
    try {
      await ApiService.addToFavourites(productId);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }

  Future<void> removeFromFavourites(String productId) async {
    try {
      await ApiService.removeFromFavourites(productId);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
