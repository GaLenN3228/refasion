import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cart.dart';
import 'file:///E:/Flutter/Production/Refashioned/ref_mobile_app/lib/services/api_service.dart';
import 'base.dart';

class CartRepository extends BaseRepository<Cart> {
  Future<void> getCart() => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getCart()).data, (contentJson) => Cart.fromJson(contentJson));
      });
}
