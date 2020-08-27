import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cities.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class CityTile extends StatelessWidget {
  final City city;
  final Function() onTap;

  const CityTile({this.city, this.onTap}) : assert(city != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap != null ? onTap : () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    city.region.name,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: city.selected,
              builder: (context, value, _) => !value
                  ? SizedBox()
                  : SVGIcon(
                      icon: IconAsset.done,
                      size: 26,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
