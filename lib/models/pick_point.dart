import 'package:refashioned_app/models/cities.dart';

class PickPoint {
  final String id;
  String address;
  String originalAddress;
  final double latitude;
  final double longitude;
  final String type;
  final String workSchedule;
  City city;

  PickPoint(
      {this.id,
      this.address,
      this.originalAddress,
      this.latitude,
      this.longitude,
      this.type: "Тип не задан",
      this.workSchedule: "Часы работы не заданы",
      this.city});

  factory PickPoint.fromJson(Map<String, dynamic> json) {
    return PickPoint(
        id: json['id'],
        address: json['address'],
        originalAddress: json['unrestricted_value'] ?? json['address'],
        latitude: double.parse(json['lat']),
        longitude: double.parse(json['lon']),
        type: json['type'],
        workSchedule: json['work_shedule']);
  }

  @override
  String toString() =>
      type.toString() +
      ". " +
      address.toString() +
      " [" +
      originalAddress.toString() +
      "] - " +
      latitude.toString() +
      ", " +
      longitude.toString() +
      ": " +
      workSchedule.toString();
}
