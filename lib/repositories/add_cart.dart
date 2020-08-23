import 'package:refashioned_app/models/base.dart';

import '../services/api_service.dart';
import 'base.dart';

class AddCartRepository extends BaseRepository {
  Future<void> addToCart(String productId) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.addToCart(productId)).data, null);
      });
}
