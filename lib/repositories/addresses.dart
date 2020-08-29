import 'dart:math';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/base.dart';
import '../services/api_service.dart';
import 'base.dart';

class AddressRepository extends BaseRepository<Address> {
  Future<void> findAddressByCoordinates(Point newCoordinates) => apiCall(
        () async {
          if (newCoordinates?.x == null || newCoordinates?.y == null)
            abortLoading(message: "No coordinates");

          response = BaseResponse.fromJson(
              (await ApiService.findAddressByCoordinates(newCoordinates)).data,
              (contentJson) => Address.fromJson(contentJson));
        },
      );
}

class AddressesRepository extends BaseRepository<List<Address>> {
  Future<void> findAddressesByQuery(String query) => apiCall(
        () async {
          if (query == null) abortLoading(message: "No query");

          response = BaseResponse.fromJson(
            (await ApiService.findAddressesByQuery(query)).data,
            (contentJson) => [
              if (contentJson != null)
                for (final address in contentJson) Address.fromJson(address)
            ],
          );
        },
      );
}
