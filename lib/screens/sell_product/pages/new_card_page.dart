import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class NewCardPage extends StatelessWidget {
  final Function() onPush;

  const NewCardPage({Key key, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: RefashionedTopBar(
              leftButtonType: TBButtonType.none,
              middleType: TBMiddleType.title,
              middleTitleText: "Новая карта",
              rightButtonType: TBButtonType.text,
              rightButtonText: "Закрыть",
              rightButtonAction: () => Navigator.of(context).pop(),
              bottomType: TBBottomType.none,
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onPush();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Новая банковская карта",
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
