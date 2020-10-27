import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

class RatingTile extends StatelessWidget {
  final double rating;
  final double starSize;
  final EdgeInsets padding;

  const RatingTile({
    @required this.rating,
    this.padding,
    this.starSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              size: starSize ?? 20,
              color: Color(0xFFEAEAEA),
            ),
          ),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: rating / 5,
            child: Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: starSize ?? 20,
                  color: accentColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
