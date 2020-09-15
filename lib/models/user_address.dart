import 'package:refashioned_app/models/pick_point.dart';

class UserAddress {
  final String id;

  final PickPoint address;

  final String pickpoint;
  final String fio;
  final String phone;
  final String email;
  final String porch;
  final String floor;
  final String appartment;
  final String intercom;
  final String comment;

  const UserAddress(
      {this.pickpoint,
      this.address,
      this.id,
      this.fio,
      this.phone,
      this.email,
      this.porch,
      this.floor,
      this.appartment,
      this.intercom,
      this.comment});

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    final pickpoint = json['pickpoint'];

    if (pickpoint != null)
      return UserAddress(
        id: json['id'],
        pickpoint: pickpoint,
        fio: json['contact_fio'],
        phone: json['contact_phone'],
        email: json['contact_email'],
        comment: json['comment'],
      );
    else
      return UserAddress(
        id: json['id'],
        address: PickPoint.fromJson(json),
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

  Map<String, dynamic> toJson() {
    if (pickpoint != null)
      return {
        "id": id,
        "pickpoint": pickpoint,
        'contact_fio': fio ?? "",
        'contact_phone': phone ?? "",
        'contact_email': email ?? "",
        'comment': comment ?? "",
      };
    else
      return {
        "id": id,
        'address': address.address ?? "",
        'unrestricted_value': address.originalAddress ?? "",
        'lat': address.latitude ?? "",
        'lon': address.longitude ?? "",
        'contact_fio': fio ?? "",
        'contact_phone': phone ?? "",
        'contact_email': email ?? "",
        'porch': porch ?? "",
        'floor': floor ?? "",
        'appartment': appartment ?? "",
        'intercom': intercom ?? "",
        'comment': comment ?? "",
      };
  }
}
