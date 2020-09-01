import 'dart:async';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cities.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Address {
  final String address;
  final String originalAddress;
  final Point coordinates;
  final City city;

  Address({this.originalAddress, this.address, this.coordinates, this.city});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      address: json['address'],
      originalAddress: json['unrestricted_value'],
      coordinates: json['lat'] != null && json['lon'] != null
          ? Point(latitude: num.tryParse(json['lat']), longitude: num.tryParse(json['lon']))
          : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null);

  @override
  String toString() =>
      address.toString() +
      " [" +
      originalAddress.toString() +
      "] - " +
      coordinates?.latitude.toString() +
      ", " +
      coordinates?.longitude.toString();
}

class AddressesProvider {
  final _addressesController = StreamController<List<Address>>();

  Stream<List<Address>> addresses;

  AddressesProvider() {
    addresses = _addressesController.stream;
  }

  update(BaseResponse<List<Address>> newResponse) {
    if (newResponse.status.code != 200) {
      throwError({"status code": newResponse.status.code});
    } else
      _addressesController.add(newResponse.content);
  }

  throwError(Object error) => _addressesController.addError({"error": error});

  clear() => _addressesController.add(List<Address>());

  dispose() {
    _addressesController.close();
  }
}
