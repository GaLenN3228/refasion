import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class SizesTableLink extends StatelessWidget {
  final Function() onTap;

  const SizesTableLink({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap?.call,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SVGIcon(
              icon: IconAsset.info,
              size: 26,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Таблица размеров",
              style: Theme.of(context).textTheme.bodyText1.copyWith(decoration: TextDecoration.underline),
            ),
          ],
        ),
      );
}
