import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/models/seller_reviews/seller_review.dart';
import 'package:refashioned_app/screens/components/seller/rating.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class SellerReviewTile extends StatelessWidget {
  final SellerReview review;

  const SellerReviewTile({Key key, this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 10, 5, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SVGIcon(
                icon: IconAsset.person,
                size: 32,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          review.customerName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      RatingTile(
                        rating: review.rating.toDouble(),
                        starSize: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                DateFormat('d.M.y HH:mm').format(review.createdAt),
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: darkGrayColor,
                    ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 15, 0, 5),
            child: Text(
              review.text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )
        ],
      ),
    );
  }
}
