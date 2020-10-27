import 'package:flutter/material.dart';
import 'package:refashioned_app/models/morphology.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/screens/components/seller/rating.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductSeller extends StatefulWidget {
  final Seller seller;
  final Function(Seller) onSellerPush;

  const ProductSeller({Key key, this.onSellerPush, this.seller}) : super(key: key);

  @override
  _ProductSellerState createState() => _ProductSellerState();
}

class _ProductSellerState extends State<ProductSeller> {
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
    if (widget.seller == null) return SizedBox();

    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => widget.onSellerPush?.call(widget.seller),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: const Color.fromRGBO(0, 0, 0, 0.05)),
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
                child: widget.seller.image != null
                    ? Image.network(
                        widget.seller.image,
                        fit: BoxFit.cover,
                        width: 44,
                        height: 44,
                      )
                    : Image.asset(
                        'assets/images/png/seller.png',
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
              widget.seller.name ?? "Камила",
              style: textTheme.subtitle1,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RatingTile(
                      rating: widget.seller.rating,
                      starSize: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        (widget.seller.rating ?? 4.2).toString(),
                        style: textTheme.caption.copyWith(fontWeight: FontWeight.w600, color: primaryColor),
                      ),
                    )
                  ],
                ),
                Text(
                  morphology.countText(widget.seller.reviewsCount).toString(),
                  style: textTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
