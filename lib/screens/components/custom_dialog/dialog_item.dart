import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class DialogItem extends StatelessWidget {
  final DialogItemContent dialogItemContent;

  const DialogItem({Key key, this.dialogItemContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
        onTap: dialogItemContent?.onClick,
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            color: Colors.white,
            child: Row(
              children: [
                SVGIcon(
                  icon: dialogItemContent.icon,
                  color: dialogItemContent.color ?? primaryColor,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      dialogItemContent.text,
                      style: dialogItemContent.dialogItemType == DialogItemType.system
                          ? textTheme.headline6
                          : textTheme.headline5
                              .copyWith(color: dialogItemContent.color ?? primaryColor),
                      maxLines: 1,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
        ));
  }
}

enum DialogItemType { item, system }

class DialogItemContent {
  final IconAsset icon;
  final Color color;
  final String text;
  final Function() onClick;
  final DialogItemType dialogItemType;

  const DialogItemContent(this.text, this.onClick, this.dialogItemType, {this.color, this.icon});

  IconAsset get getIcon => icon;

  String get getText => text;
}
