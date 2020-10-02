import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/services/api_service.dart';

class GetCartItemDeliveryTypesRepository extends BaseRepository<List<DeliveryType>> {
  Future<void> update(String id) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.getCartItemDeliveryTypes(id)).data,
              (contentJson) => [for (final type in contentJson) DeliveryType.fromJson(type)]
                  .where((element) => element != null)
                  .toList());
        },
      );
}
