import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_bottom.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_button.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_middle.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class OnModerationPage extends StatelessWidget {
  final Function() onClose;

  const OnModerationPage({Key key, this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          TopBar(
            leftButtonType: TBButtonType.none,
            middleType: TBMiddleType.text,
            middleText: "На модерации",
            rightButtonType: TBButtonType.text,
            rightButtonText: "Закрыть",
            rightButtonAction: onClose,
            bottomType: TBBottomType.none,
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onClose,
                  child: Text(
                    "Спасибо!",
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
