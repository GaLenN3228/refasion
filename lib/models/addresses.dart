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

class UserAddress {
  final PickPoint pickPoint;

  final String fio;
  final String phone;
  final String email;
  final String porch;
  final String floor;
  final String appartment;
  final String intercom;
  final String comment;

  const UserAddress(
      {this.pickPoint,
      this.fio,
      this.phone,
      this.email,
      this.porch,
      this.floor,
      this.appartment,
      this.intercom,
      this.comment});

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        pickPoint: PickPoint.fromJson(json),
        fio: json['contact_fio'],
        phone: json['contact_phone'],
        email: json['contact_email'],
        porch: json['porch'],
        floor: json['floor'],
        appartment: json['appartment'],
        intercom: json['intercom'],
        comment: json['comment'],
      );
}
