import 'package:flutter/material.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/screens/product/components/rating.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductSeller extends StatelessWidget {
  final Seller seller;
  final Function(Seller) onSellerPush;

  const ProductSeller({Key key, this.onSellerPush, this.seller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (seller == null) return SizedBox();

    TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onSellerPush(seller),
      child: Container(
        margin: EdgeInsets.only(top: 25, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border:
              Border.all(width: 1, color: const Color.fromRGBO(0, 0, 0, 0.05)),
        ),
        child: ListTile(
          isThreeLine: false,
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          leading: Container(
            width: 44,
            height: 44,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: seller.image != null
                  ? Image.network(
                      seller.image,
                      fit: BoxFit.cover,
                      width: 44,
                      height: 44,
                    )
                  : Image.asset(
                      'assets/seller.png',
                      fit: BoxFit.cover,
                      width: 44,
                      height: 44,
                    ),
            ),
          ),
          title: Text(
            "Продавец",
            style: textTheme.caption,
          ),
          subtitle: Text(
            seller.name ?? "Камила",
            style: textTheme.subtitle1,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Rating(4.8),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      (seller.rating ?? 4.2).toString(),
                      style: textTheme.caption.copyWith(
                          fontWeight: FontWeight.w600, color: primaryColor),
                    ),
                  )
                ],
              ),
              Text(
                (seller.reviewsCount ?? 7).toString() + " отзывов",
                style: textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
