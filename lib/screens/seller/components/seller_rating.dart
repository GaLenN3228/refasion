import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/morphology.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/seller/rating.dart';

class SellerRating extends StatefulWidget {
  final Seller seller;
  final Function() onSellerReviewsPush;

  const SellerRating({Key key, this.seller, this.onSellerReviewsPush}) : super(key: key);

  @override
  _SellerRatingState createState() => _SellerRatingState();
}

class _SellerRatingState extends State<SellerRating> {
  Morphology morphology;

  @override
  void initState() {
    morphology = Morphology(
      zeroOf: "нет оценок",
      oneOf: "оценка",
      twoOf: "оценки",
      fiveOf: "оценок",
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onSellerReviewsPush?.call,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.seller.rating > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      widget.seller.rating.toString(),
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: 48,
                          ),
                    ),
                  ),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingTile(rating: widget.seller.rating),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(
                                morphology.countText(widget.seller.reviewsCount).toString(),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Смотреть всё",
                          // widget.seller.reviewsCount > 0 ? "Смотреть всё" : "Оставить отзыв",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ItemsDivider(),
        ],
      ),
    );
  }
}
