import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class SectionTile extends StatelessWidget {
  final Function(Category) onPush;
  final Category section;

  const SectionTile({Key key, this.onPush, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onPush != null) onPush(section);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: ShapeDecoration(shape: CircleBorder()),
            child: SVGIcon(
              icon: SectionTile.getSectionIcon(section),
              size: 60,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Text(
              section.name,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          )
        ],
      ),
    );
  }

  static IconAsset getSectionIcon(Category category) {
    switch (category.name) {
      case "Женщинам":
        return IconAsset.marketPlaceCategory3;
      case "Мужчинам":
        return IconAsset.marketPlaceCategory2;
      case "Детям":
        return IconAsset.marketPlaceCategory1;
      default:
        return IconAsset.marketPlaceCategory3;
    }
  }
}
