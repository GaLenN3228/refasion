import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/services/api_service.dart';

class AddProductToCartRepository extends BaseRepository {
  Future<void> update(String id) => apiCall(
        () async {
          response = BaseResponse.fromJson((await ApiService.addProductToCart(id)).data, null);
        },
      );
}
