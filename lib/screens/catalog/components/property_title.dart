import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/models/property.dart';

class PropertyTitle extends StatelessWidget {
  final Function() onPop;
  final Property property;

  const PropertyTitle({Key key, this.onPop, this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onPop(),
            child: SvgPicture.asset(
              "assets/back.svg",
              color: Color(0xFF222222),
              width: 44,
            ),
          ),
          Text(
            property.property.toUpperCase(),
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            width: 44,
          ),
        ],
      ),
    );
  }
}
