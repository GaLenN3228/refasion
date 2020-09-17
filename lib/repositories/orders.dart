import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/services/api_service.dart';

class OrdersRepository extends BaseRepository {
  Future<void> update(String parameters) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.makeOrder(parameters)).data, null);
        },
      );
}
