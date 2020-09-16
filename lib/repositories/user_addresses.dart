import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/services/api_service.dart';

class GetUserAddressRepository extends BaseRepository<UserAddress> {
  Future<void> update(String id) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.getUserAddress(id)).data,
            (contentJson) => UserAddress.fromJson(contentJson),
          );
        },
      );
}

class AddUserAddressRepository extends BaseRepository<UserAddress> {
  Future<void> update(String json) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.addUserAddress(json)).data,
            (contentJson) => UserAddress.fromJson(contentJson),
          );
        },
      );
}

class RemoveUserAddressRepository extends BaseRepository {
  Future<void> update(String id) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.removeUserAddress(id)).data, null);
        },
      );
}

class GetUserAddressesRepository extends BaseRepository<List<UserAddress>> {
  Future<void> update() => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.getUserAddresses()).data,
            (contentJson) =>
                [for (final json in contentJson) UserAddress.fromJson(json)],
          );
        },
      );
}
