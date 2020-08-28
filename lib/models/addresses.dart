import 'dart:math';

import 'package:refashioned_app/models/cities.dart';
import 'package:refashioned_app/models/status.dart';

class AddressesResponse {
  final Status status;
  final List<Address> content;

  const AddressesResponse({this.status, this.content});

  factory AddressesResponse.fromJson(Map<String, dynamic> json) {
    return AddressesResponse(status: Status.fromJson(json['status']), content: [
      if (json['content'] != null)
        for (final address in json['content']) Address.fromJson(address)
    ]);
  }
}

class AddressResponse {
  final Status status;
  final Address content;

  const AddressResponse({this.status, this.content});

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
        status: Status.fromJson(json['status']),
        content: Address.fromJson(json['content']));
  }
}

class Address {
  final String address;
  final String originalAddress;
  final Point coordinates;
  final City city;

  Address({this.originalAddress, this.address, this.coordinates, this.city});

  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      final newAddress = Address(
          address: json['address'],
          originalAddress: json['unrestricted_value'],
          coordinates: json['lat'] != null && json['lon'] != null
              ? Point(num.tryParse(json['lat']), num.tryParse(json['lon']))
              : null,
          city: json['city'] != null ? City.fromJson(json['city']) : null);
      print(newAddress);
      return newAddress;
    } catch (err) {
      print("Address parse error: " + err.toString());
      return null;
    }
  }

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
