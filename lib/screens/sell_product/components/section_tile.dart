import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
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
            decoration:
                ShapeDecoration(shape: CircleBorder(), color: primaryColor),
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
}
