import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_settings.dart';

final _deliveryOptionsMockup = [
  DeliveryOptionData(
    deliveryType: DeliveryType.PICKUP_ADDRESS,
    title: "Самовывоз от продавца",
    subtitle: "Бесплатно. По адресу продавца.",
  ),
  DeliveryOptionData(
    deliveryType: DeliveryType.PICKUP_POINT,
    title: "Доставка в пункт выдачи",
    subtitle: "От 120 ₽. Более 3000 пунктов.",
  ),
  DeliveryOptionData(
    deliveryType: DeliveryType.COURIER_DELIVERY,
    title: "Доставка курьером",
    subtitle: "От 250 ₽. В течение 2-3 дней.",
  ),
  DeliveryOptionData(
    deliveryType: DeliveryType.EXPRESS_DEVILERY,
    title: "Экспрессс-доставка",
    subtitle: "От 400 ₽. В течение 1-3 часов.",
  ),
];

class CartGroupData {
  final String deliveryObject;
  final String deliveryData;
  final List<Product> products;

  CartGroupData({this.products, this.deliveryObject, this.deliveryData});

  factory CartGroupData.fromJson(Map<String, dynamic> json) => CartGroupData(
        deliveryData: json['delivaery_data'],
        deliveryObject: json['delivery_object'],
        products: [
          for (final itemProduct in json['item_products'])
            Product.fromJson(itemProduct['product'])
        ],
      );

  List<DeliveryOptionData> _availableDeliveryOptions = _deliveryOptionsMockup;
  List<DeliveryOptionData> get availableDeliveryOptions =>
      _availableDeliveryOptions;

  List<DeliveryOptionData> _userDeliveryPresets;
  List<DeliveryOptionData> get userDeliveryPresets => _userDeliveryPresets;

  DeliverySettings _deliveryPreset;
  DeliverySettings get deliveryPreset => _deliveryPreset;

  DeliverySettings newPreset;
}
