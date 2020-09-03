import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class CompassButton extends StatelessWidget {
  final ValueNotifier<bool> show;
  final Function onTap;

  const CompassButton({Key key, this.onTap, this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: show ?? ValueNotifier(false),
      builder: (context, value, child) {
        if (value)
          return child;
        else
          return Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: SizedBox(
              width: 30,
              height: 30,
            ),
          );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
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
            child: SVGIcon(icon: IconAsset.compass),
          ),
        ),
      ),
    );
  }
}
