
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

  Future<void> addToFavourites() async {
    try {
      await ApiService.addToFavourites("", "");

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }

  Future<void> removeFromFavourites() async {
    try {
      await ApiService.removeFromFavourites("", "");

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
