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
  AnimationController animationController;

  Animation<double> animation;
  Animation<double> slideAnimation;
  Animation<double> fadeAnimation;

  bool showIndicator;

  @override
  void initState() {
    showIndicator = false;

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    slideAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(0.4, 1.0, curve: Curves.easeInOut),
    );
    fadeAnimation = ReverseAnimation(
      CurvedAnimation(
        parent: animation,
        curve: Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => postFrameCallback());

    super.initState();
  }

  @override
  dispose() {
    animationController.dispose();

    super.dispose();
  }

  postFrameCallback() async => await animationController.forward();

  onPush() async {
    setState(() => showIndicator = true);

    await animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: showIndicator
              ? FadeTransition(
                  opacity: fadeAnimation,
                  child: Theme(
                    data: ThemeData(
                      cupertinoOverrideTheme: CupertinoThemeData(
                        brightness: Brightness.dark,
                      ),
                    ),
                    child: CupertinoActivityIndicator(
                      radius: 14,
                    ),
                  ),
                )
              : SizedBox(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0.0, 1.2), end: Offset.zero).animate(slideAnimation),
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
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.dialogContent
                            .where((element) =>
                                element.dialogItemType == DialogItemType.item ||
                                element.dialogItemType == DialogItemType.infoHeader)
                            .length,
                        itemBuilder: (context, index) => DialogItem(
                          dialogItemContent: widget.dialogContent
                              .where((element) =>
                                  element.dialogItemType == DialogItemType.item ||
                                  element.dialogItemType == DialogItemType.infoHeader)
                              .elementAt(index),
                          onPush: onPush,
                        ),
                        separatorBuilder: (context, index) => ItemsDivider(
                          padding: 0,
                        ),
                      ),
                    ),
                    if (widget.dialogContent.any((element) => element.dialogItemType == DialogItemType.system))
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        decoration: ShapeDecoration(
                          color: dialogColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.dialogContent
                              .where((element) => element.dialogItemType == DialogItemType.system)
                              .length,
                          itemBuilder: (context, index) => DialogItem(
                            dialogItemContent: widget.dialogContent
                                .where((element) => element.dialogItemType == DialogItemType.system)
                                .elementAt(index),
                            onPush: onPush,
                          ),
                          separatorBuilder: (context, index) => ItemsDivider(
                            padding: 0,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
