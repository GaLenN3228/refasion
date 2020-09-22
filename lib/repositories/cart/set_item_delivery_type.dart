import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/services/api_service.dart';

class SetCartItemDeliveryTypeRepository extends BaseRepository {
  Future<void> update(String itemId, String deliveryCompanyId, String deliveryObjectId) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.setCartItemDeliveryType(
                      itemId, deliveryCompanyId, deliveryObjectId))
                  .data,
              null);
        },
      );
}
