import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

class Rating extends StatelessWidget {
  final double rating;

  const Rating(this.rating);

  /// 0 - 0.3 - empty
  ///
  /// 0.3 - 0.8 - star half
  ///
  /// 0.8 - 1 - star full
  Widget _lastIcon(){
    double halfValue = rating % 1;
    if(halfValue < 0.3){
      return Container();
    }else if(halfValue < 0.8){
      return Icon(Icons.star_half, size: 10, color: accentColor);
    }else {
      return Icon(Icons.star, size: 10, color: accentColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < rating - 1; i++) Icon(Icons.star, size: 10, color: accentColor),
        _lastIcon(),
      ],
    );
  }
}
