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
        onTap: dialogItemContent?.onClick ?? () {},
        child: dialogItemContent.dialogItemType == DialogItemType.infoHeader
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      child: Text(
                        dialogItemContent.title,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 6, bottom: 18, left: 36, right: 36),
                        child: Text(
                          dialogItemContent.subTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                  ])
            : Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  padding: EdgeInsets.only(top: 13, bottom: 13),
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
                            dialogItemContent.title,
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

enum DialogItemType { item, system, infoHeader }

class DialogItemContent {
  final IconAsset icon;
  final Color color;
  final String title;
  final String subTitle;
  final Function() onClick;
  final DialogItemType dialogItemType;

  const DialogItemContent(this.dialogItemType,
      {this.title, this.onClick, this.color, this.icon, this.subTitle});

  IconAsset get getIcon => icon;

  String get getText => title;
}
