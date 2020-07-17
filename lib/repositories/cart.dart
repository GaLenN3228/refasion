import 'package:dio/dio.dart';
import 'package:refashioned_app/models/cart.dart';
import '../services/api_service.dart';
import 'base.dart';

class CartRepository extends BaseRepository {
  CartResponse cartResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response cartResponse = await ApiService.getCart();

      this.cartResponse = CartResponse.fromJson(cartResponse.data);

      finishLoading();
    } catch (err) {
      print("CartRepository error:");
      print(err);
      receivedError();
    }
  }
}
