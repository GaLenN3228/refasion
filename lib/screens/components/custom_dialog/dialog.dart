import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/custom_dialog/dialog_item.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/utils/colors.dart';

class Dialog extends StatefulWidget {
  final List<DialogItemContent> dialogContent;

  const Dialog({Key key, this.dialogContent}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DialogState();
}

class DialogState extends State<Dialog> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: offset,
            child: Container(
              margin: EdgeInsets.all(10.0),
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: ShapeDecoration(
                          color: dialogColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0))),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.dialogContent
                            .where((element) =>
                                element.dialogItemType == DialogItemType.item)
                            .length,
                        itemBuilder: (context, index) => DialogItem(
                          dialogItemContent: widget.dialogContent
                              .where((element) =>
                                  element.dialogItemType == DialogItemType.item)
                              .elementAt(index),
                        ),
                        separatorBuilder: (context, index) => ItemsDivider(
                          padding: 0,
                        ),
                      ),
                    ),
                    if (widget.dialogContent.any((element) =>
                        element.dialogItemType == DialogItemType.system))
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          decoration: ShapeDecoration(
                              color: dialogColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0))),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.dialogContent
                                .where((element) =>
                                    element.dialogItemType ==
                                    DialogItemType.system)
                                .length,
                            itemBuilder: (context, index) => DialogItem(
                              dialogItemContent: widget.dialogContent
                                  .where((element) =>
                                      element.dialogItemType ==
                                      DialogItemType.system)
                                  .elementAt(index),
                            ),
                            separatorBuilder: (context, index) => ItemsDivider(
                              padding: 0,
                            ),
                          ))
                  ]),
            ),
          ),
        ));
  }
}
