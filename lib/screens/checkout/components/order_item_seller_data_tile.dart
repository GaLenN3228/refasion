import 'package:flutter/material.dart';
import 'package:refashioned_app/models/seller.dart';

class OrderItemSellerDataTile extends StatelessWidget {
  final String text;
  final Seller seller;

  const OrderItemSellerDataTile({Key key, this.text, this.seller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7.5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: seller.image != null
                ? Image.network(
                    seller.image,
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
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
