import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/utils/colors.dart';

class DialogItem extends StatelessWidget {
  final DialogItemContent dialogItemContent;

  const DialogItem({Key key, this.dialogItemContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
        onTap: () => dialogItemContent.onClick(),
        child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(top: 18, left: 20, right: 20, bottom: 18),
            child: Stack(children: [
              (dialogItemContent.dialogItemType == DialogItemType.item && dialogItemContent.icon != null)
                  ? Container(
                      width: 20,
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        dialogItemContent.icon,
                        width: 20,
                      ))
                  : ((dialogItemContent.dialogItemType == DialogItemType.system) ? SizedBox() : SizedBox()),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    dialogItemContent.text,
                    style: (dialogItemContent.dialogItemType == DialogItemType.system)
                        ? textTheme.headline6
                        : textTheme.headline5,
                    maxLines: 1,
                  )),
            ])));
  }
}

enum DialogItemType { item, system }

class DialogItemContent {
  final String icon;
  final String text;
  final Function() onClick;
  final DialogItemType dialogItemType;

  const DialogItemContent(this.text, this.onClick, this.dialogItemType, {this.icon});

  String get getIcon => icon;

  String get getText => text;
}
