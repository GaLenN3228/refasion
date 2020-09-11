import 'dart:async';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/repositories/SearchGeneralRepository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../services/api_service.dart';
import 'base.dart';

class AddressRepository extends BaseRepository<Address> {
  Future<void> findAddressByCoordinates(Point newCoordinates) => apiCall(
        () async {
          if (newCoordinates?.latitude == null ||
              newCoordinates?.longitude == null)
            abortLoading(message: "No coordinates");

          response = BaseResponse.fromJson(
              (await ApiService.findAddressByCoordinates(newCoordinates)).data,
              (contentJson) => Address.fromJson(contentJson));
        },
      );
}

class GetAddressRepository extends BaseRepository<UserAddress> {
  Future<void> update(String id) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.getAddress(id)).data,
            (contentJson) => UserAddress.fromJson(contentJson),
          );
        },
      );
}

class AddAddressRepository extends BaseRepository<UserAddress> {
  Future<void> update(String json) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.addAddress(json)).data,
            (contentJson) => UserAddress.fromJson(contentJson),
          );
        },
      );
}

class RemoveAddressRepository extends BaseRepository {
  Future<void> update(String id) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.removeAddress(id)).data, null);
        },
      );
}

class GetAddressesRepository extends BaseRepository<List<UserAddress>> {
  Future<void> update() => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.getAddresses()).data,
            (contentJson) =>
                [for (final json in contentJson) UserAddress.fromJson(json)],
          );
        },
      );
}

class AddressesRepository extends SearchGeneralRepository<List<Address>> {
  update(String query) => callSearchApi(query, () async {
        response = BaseResponse.fromJson(
          (await ApiService.findAddressesByQuery(query)).data,
          (contentJson) => contentJson.fold(
            List<Address>(),
            (list, address) {
              final newAddress = Address.fromJson(address);
              if (newAddress?.coordinates != null) list.update(newAddress);
              return list;
            },
          ),
        );
      });
}
