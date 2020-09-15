import 'dart:convert';

import 'package:refashioned_app/models/order/order_item.dart';

class Order {
  final List<OrderItem> items;

  Order({this.items});

  String getParameters() => jsonEncode(items);
}
