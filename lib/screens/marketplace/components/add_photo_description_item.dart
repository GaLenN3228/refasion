import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class AddPhotoDescriptionItem extends StatelessWidget {
  final String title;

  const AddPhotoDescriptionItem({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 20, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SVGIcon(
            icon: IconAsset.done,
            color: accentColor,
            size: 26,
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: textTheme.subtitle1,
                  maxLines: 2,
                )),
          ),
        ],
      ),
    );
  }
}
