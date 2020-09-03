import 'package:refashioned_app/models/cities.dart';

class PickPoint {
  String address;
  String originalAddress;
  final double latitude;
  final double longitude;
  final String type;
  final String workSchedule;
  City city;

  PickPoint({this.address, this.originalAddress, this.latitude, this.longitude, this.type, this.workSchedule, this.city});

  factory PickPoint.fromJson(Map<String, dynamic> json) {
    return PickPoint(
        address: json['address'],
        latitude: double.parse(json['lat']),
        longitude: double.parse(json['lon']),
        type: json['type'],
        workSchedule: json['work_shedule']);
  }
}
