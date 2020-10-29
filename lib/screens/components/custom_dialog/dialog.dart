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

class DialogState extends State<Dialog> with TickerProviderStateMixin {
  AnimationController dialogAnimationController;
  Animation<double> dialogAnimation;

  AnimationController indicatorAnimationController;
  Animation<double> fadeAnimation;

  @override
  void initState() {
    dialogAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    dialogAnimation = Tween(begin: 0.0, end: 1.0).animate(dialogAnimationController);

    indicatorAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(indicatorAnimationController);

    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);

    super.initState();
  }

  @override
  dispose() {
    dialogAnimationController.dispose();

    super.dispose();
  }

  postFrameCallback(Duration _) async => await dialogAnimationController.forward();

  Future<void> hideDialog() async => await dialogAnimationController.reverse();

  Future<void> showIndicator() async => await indicatorAnimationController.forward();
  Future<void> hideIndicator() async => await indicatorAnimationController.reverse();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: FadeTransition(
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
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0.0, 1.2), end: Offset.zero).animate(dialogAnimation),
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
                          hideDialog: hideDialog,
                          showIndicator: showIndicator,
                          hideIndicator: hideIndicator,
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
                            hideDialog: hideDialog,
                            showIndicator: showIndicator,
                            hideIndicator: hideIndicator,
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
