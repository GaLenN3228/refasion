import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/order/order_producr.dart';

class OrderProductTile extends StatelessWidget {
  final OrderProduct orderProduct;

  const OrderProductTile({this.orderProduct});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 5, right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            orderProduct.image != null
                ? orderProduct.image
                : "https://admin.refashioned.ru/media/product/2c8cb353-4feb-427d-9279-d2b75f46d786/2b22b56279182fe9bedb1f246d9b44b7.JPG",
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      );
}
