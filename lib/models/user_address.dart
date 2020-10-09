import 'package:refashioned_app/models/pick_point.dart';

enum UserAddressType { address, pickpoint, boxberry_pickpoint }

final _userAddressTypesLabels = {
  "address": UserAddressType.address,
  "pickpoint": UserAddressType.pickpoint,
  "boxberry-pickpoint": UserAddressType.boxberry_pickpoint,
};

class UserAddress {
  final String id;
  final String pickpoint;

  final UserAddressType type;

  final PickPoint address;

  String fio;
  String phone;
  String email;

  final String porch;
  final String floor;
  final String appartment;
  final String intercom;
  final String comment;
  final bool isPrivateHouse;

  UserAddress({
    this.type,
    this.isPrivateHouse,
    this.pickpoint,
    this.address,
    this.id,
    this.fio,
    this.phone,
    this.email,
    this.porch,
    this.floor,
    this.appartment,
    this.intercom,
    this.comment,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    final extraData = json['extra_data'];

    final type = json['type'] != null ? _userAddressTypesLabels[json['type']] : null;

    return UserAddress(
      id: json['id'],
      pickpoint: json['pickpoint'],
      type: type,
      address: PickPoint.fromJson(json),
      fio: json['contact_fio'],
      phone: json['contact_phone'],
      email: json['contact_email'],
      porch: extraData != null ? extraData['porch'] : null,
      isPrivateHouse: extraData != null ? extraData['is_private_house'] : null,
      floor: extraData != null ? extraData['floor'] : null,
      appartment: extraData != null ? extraData['appartment'] : null,
      intercom: extraData != null ? extraData['intercom'] : null,
      comment: extraData != null ? extraData['comment'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "pickpoint": pickpoint,
        "type": _userAddressTypesLabels.entries.firstWhere((element) => element.value == type, orElse: () => null)?.key,
        'address': address?.address ?? "",
        'unrestricted_value': address?.originalAddress ?? "",
        'lat': address?.latitude ?? "",
        'lon': address?.longitude ?? "",
        'contact_fio': fio ?? "",
        'contact_phone': phone ?? "",
        'contact_email': email ?? "",
        'porch': porch ?? "",
        'floor': floor ?? "",
        'appartment': appartment ?? "",
        'intercom': intercom ?? "",
        'comment': comment ?? "",
        'is_private_house': isPrivateHouse ?? false,
      };
}
