import 'package:refashioned_app/models/cities.dart';
import 'package:refashioned_app/models/pick_point.dart';
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
          ? Point(
              latitude: num.tryParse(json['lat']),
              longitude: num.tryParse(json['lon']))
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
