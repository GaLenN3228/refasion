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
  final addressesProvider = AddressesProvider();

  String oldQuery;

  findAddressesByQuery(String query) async {
    if (query != oldQuery) {
      if (query == null || query.isEmpty)
        addressesProvider.clear();
      else {
        await apiCall(
          () async {
            try {
              response = BaseResponse.fromJson(
                (await ApiService.findAddressesByQuery(query)).data,
                (contentJson) => contentJson.fold(
                  List<Address>(),
                  (list, address) {
                    final newAddress = Address.fromJson(address);
                    if (newAddress?.coordinates != null) list.add(newAddress);
                    return list;
                  },
                ),
              );
              addressesProvider.update(response);
            } catch (err) {
              addressesProvider.throwError(err);
            }
          },
        );
      }
      oldQuery = query;
    }
  }

  @override
  void dispose() {
    addressesProvider.dispose();

    super.dispose();
  }
}
