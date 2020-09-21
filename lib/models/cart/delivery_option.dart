import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/pick_point.dart';

class DeliveryOption {
  final DeliveryCompany deliveryCompany;
  final PickPoint deliveryObject;

  const DeliveryOption({this.deliveryCompany, this.deliveryObject});

  factory DeliveryOption.fromJson(Map<String, dynamic> json) => json != null
      ? DeliveryOption(
          deliveryCompany: DeliveryCompany.fromJson(json['delivery_company']),
          deliveryObject: PickPoint.fromJson(json['delivery_object']),
        )
      : null;
}
