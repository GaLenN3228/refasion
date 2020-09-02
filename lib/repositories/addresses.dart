import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/repositories/SearchGeneralRepository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../services/api_service.dart';
import 'base.dart';

class AddressRepository extends BaseRepository<Address> {
  Future<void> findAddressByCoordinates(Point newCoordinates) => apiCall(
        () async {
          if (newCoordinates?.latitude == null || newCoordinates?.longitude == null) abortLoading(message: "No coordinates");

          response = BaseResponse.fromJson((await ApiService.findAddressByCoordinates(newCoordinates)).data,
              (contentJson) => Address.fromJson(contentJson));
        },
      );
}

class AddressesRepository extends SearchGeneralRepository<List<Address>> {
  final addressesProvider = AddressesProvider();

  findAddressesByQuery(String query) => callSearchApi(query, () async {
        if (searchStatus == SearchStatus.EMPTY_QUERY) {
          addressesProvider.clear();
          return;
        }
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
      });

  @override
  void dispose() {
    addressesProvider.dispose();
    super.dispose();
  }
}
