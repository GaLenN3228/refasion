import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class GeolocationButton extends StatelessWidget {
  final Function onGeolocationButtonClick;

  const GeolocationButton({Key key, this.onGeolocationButtonClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => {onGeolocationButtonClick()},
            child: Container(
                margin: EdgeInsets.all(16),
                width: 50,
                height: 50,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(child: SVGIcon(icon: IconAsset.geolocation)))));
  }
}
