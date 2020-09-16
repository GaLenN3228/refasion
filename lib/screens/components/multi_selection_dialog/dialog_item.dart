import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class DialogItem extends StatelessWidget {
  final DialogItemContent dialogItemContent;

  const DialogItem({Key key, this.dialogItemContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
      onTap: dialogItemContent?.onClick,
      child: Row(
        children: [
          SVGIcon(
            icon: dialogItemContent.icon,
          ),
          Expanded(
            child: Center(
              child: Text(
                dialogItemContent.text,
                style:
                dialogItemContent.dialogItemType == DialogItemType.system
                    ? textTheme.headline6
                    : textTheme.headline5,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
    ),);
  }
}

enum DialogItemType { item, system }

class DialogItemContent {
  final IconAsset icon;
  final String text;
  final Function() onClick;
  final DialogItemType dialogItemType;

  const DialogItemContent(this.text, this.onClick, this.dialogItemType,
      {this.icon});

  IconAsset get getIcon => icon;

  String get getText => text;
}
