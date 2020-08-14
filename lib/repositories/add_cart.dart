import '../services/api_service.dart';
import 'base.dart';

class AddCartRepository extends BaseRepository {
  final String productId;

  AddCartRepository(this.productId);

  @override
  Future<void> loadData() async {
    try {
      await ApiService.addToCart(productId);
      finishLoading();
    } catch (err) {
      print("CartRepository error:");
      print(err);
      receivedError();
    }
  }
}
