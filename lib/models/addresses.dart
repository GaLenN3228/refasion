import 'dart:math';
import 'package:refashioned_app/models/cities.dart';

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
          ? Point(num.tryParse(json['lat']), num.tryParse(json['lon']))
          : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null);

  @override
  String toString() =>
      address.toString() +
      "\n" +
      "[" +
      originalAddress.toString() +
      "]" +
      "\n" +
      coordinates?.x.toString() +
      ", " +
      coordinates?.y.toString() +
      "\n" +
      city.toString();
}
