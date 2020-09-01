import 'package:refashioned_app/models/status.dart';

class PickPoint {
  String address;
  final double latitude;
  final double longitude;
  final String type;
  final String workSchedule;

  PickPoint({this.address, this.latitude, this.longitude, this.type, this.workSchedule});

  factory PickPoint.fromJson(Map<String, dynamic> json) {
    return PickPoint(
        address: json['address'],
        latitude: double.parse(json['lat']),
        longitude: double.parse(json['lon']),
        type: json['type'],
        workSchedule: json['work_shedule']);
  }
}
