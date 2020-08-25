import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cart.dart';
import 'package:refashioned_app/services/api_service.dart';
import 'base.dart';

class CartRepository extends BaseRepository<Cart> {
  Future<void> getCart() => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getCart()).data, (contentJson) => Cart.fromJson(contentJson));
      });
}
