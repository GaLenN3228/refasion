import 'package:refashioned_app/models/status.dart';

class PickPointResponse {
  final Status status;
  final List<PickPoint> content;

  const PickPointResponse({this.status, this.content});

  factory PickPointResponse.fromJson(Map<String, dynamic> json) {
    return PickPointResponse(status: Status.fromJson(json['status']), content: [
      if (json['content'] != null)
        for (final pickPoint in json['content']) PickPoint.fromJson(pickPoint)
    ]);
  }
}

class PickPoint {
  final String address;
  final String lat;
  final String lon;
  final String type;
  final String workSchedule;

  const PickPoint({this.address, this.lat, this.lon, this.type, this.workSchedule});

  factory PickPoint.fromJson(Map<String, dynamic> json) {
    return PickPoint(
        address: json['address'],
        lat: json['lat'],
        lon: json['lon'],
        type: json['type'],
        workSchedule: json['work_shedule']);
  }
}
