import 'package:refashioned_app/models/status.dart';

class PickPoint {
  String address;
  final String lat;
  final String lon;
  final String type;
  final String workSchedule;

  PickPoint({this.address, this.lat, this.lon, this.type, this.workSchedule});

  factory PickPoint.fromJson(Map<String, dynamic> json) {
    return PickPoint(
        address: json['address'],
        lat: json['lat'],
        lon: json['lon'],
        type: json['type'],
        workSchedule: json['work_shedule']);
  }
}
