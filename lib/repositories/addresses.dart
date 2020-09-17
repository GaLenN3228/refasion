import 'dart:async';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cities.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/repositories/search_general_repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../services/api_service.dart';
import 'base.dart';

class AddressRepository extends BaseRepository<PickPoint> {
  Future<void> update(Point newCoordinates) => apiCall(
        () async {
          if (newCoordinates?.latitude == null ||
              newCoordinates?.longitude == null)
            abortLoading(message: "No coordinates");

          response = BaseResponse.fromJson(
              (await ApiService.findAddressByCoordinates(newCoordinates)).data,
              (contentJson) => PickPoint.fromJson(contentJson));
        },
      );
}

class AddressesRepository extends SearchGeneralRepository<List<PickPoint>> {
  update(String query, {City city}) => callSearchApi(query, () async {
        response = BaseResponse.fromJson(
          (await ApiService.findAddressesByQuery(query)).data,
          (contentJson) => contentJson.fold(
            List<PickPoint>(),
            (list, address) {
              final newAddress = PickPoint.fromJson(address);
              if (newAddress.latitude != null && newAddress.longitude != null) {
                list.add(newAddress);
              }
              return list;
            },
          ),
        );
      });
}
