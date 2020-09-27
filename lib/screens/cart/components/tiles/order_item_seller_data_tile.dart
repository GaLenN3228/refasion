import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_data.dart';
import 'package:refashioned_app/models/seller.dart';

class OrderItemSellerDataTile extends StatefulWidget {
  final DeliveryData deliveryData;
  final Seller seller;

  const OrderItemSellerDataTile({Key key, this.deliveryData, this.seller}) : super(key: key);

  @override
  _OrderItemSellerDataTileState createState() => _OrderItemSellerDataTileState();
}

class _OrderItemSellerDataTileState extends State<OrderItemSellerDataTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7.5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: widget.seller.image != null
                ? Image.network(
                    widget.seller.image,
                    height: 20,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/png/seller.png",
                      height: 20,
                    ),
                  ),
          ),
          Text(
            widget.deliveryData.text,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
