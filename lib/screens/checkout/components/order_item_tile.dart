import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/order/order_item.dart';
import 'package:refashioned_app/screens/checkout/components/order_item_delivery_object_tile.dart';
import 'package:refashioned_app/screens/checkout/components/order_item_seller_data_tile.dart';
import 'package:refashioned_app/screens/checkout/components/order_product_tile.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItem orderItem;

  const OrderItemTile({Key key, this.orderItem}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderItemDeliveryObjectTile(
            deliveryObject: orderItem.deliveryObject,
            delivery: orderItem.shippingCost.shipping,
          ),
          OrderItemSellerDataTile(
            seller: orderItem.seller,
            text: orderItem.deliveryText,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7.5, bottom: 25),
            child: SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final product in orderItem.products)
                    OrderProductTile(
                      orderProduct: product,
                    ),
                ],
              ),
            ),
          ),
          ItemsDivider(
            padding: 5,
          ),
        ],
      );
}
