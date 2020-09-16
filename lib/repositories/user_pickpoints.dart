import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/services/api_service.dart';

class AddUserPickPointRepository extends BaseRepository<UserAddress> {
  Future<void> update(String json) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.addUserPickPoint(json)).data,
            (contentJson) => UserAddress.fromJson(contentJson),
          );
        },
      );
}

class GetUserPickPointsRepository extends BaseRepository<List<UserAddress>> {
  Future<void> update() => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.getUserPickPoints()).data,
            (contentJson) =>
                [for (final json in contentJson) UserAddress.fromJson(json)],
          );
        },
      );
}
