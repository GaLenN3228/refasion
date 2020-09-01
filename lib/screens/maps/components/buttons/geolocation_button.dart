import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class GeolocationButton extends StatelessWidget {
  final Function onTap;

  const GeolocationButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, bottom: 10),
        child: Container(
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
              shadows: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                  color: Colors.black.withOpacity(0.15),
                )
              ]),
          padding: const EdgeInsets.all(8),
          child: SVGIcon(icon: IconAsset.geolocation),
        ),
      ),
    );
  }
}
