import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
import 'package:refashioned_app/screens/cart/delivery/data/recipient_info.dart';

class DeliverySettings extends ChangeNotifier {
  PickPoint _pickPoint;
  PickPoint get pickPoint => _pickPoint;

  DeliveryType _deliveryOption;
  DeliveryType get deliveryOption => _deliveryOption;

  RecipientInfo _recipientInfo;
  RecipientInfo get recipientInfo => _recipientInfo;

  updatePickPoint(PickPoint newPickPoint) {
    _pickPoint = newPickPoint;
    notifyListeners();
  }

  updateDeliveryOption(DeliveryType newDeliveryOption) {
    _deliveryOption = newDeliveryOption;
    notifyListeners();
  }

  updateRecipientInfo(RecipientInfo newRecipientInfo) {
    _recipientInfo = newRecipientInfo;
    notifyListeners();
  }
}
