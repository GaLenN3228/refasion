import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class OnModerationPage extends StatelessWidget {
  final Function() onClose;

  const OnModerationPage({Key key, this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          RefashionedTopBar(
            data: TopBarData.sellerPage(
              titleText: "На модерации",
              rightAction: onClose,
            ),
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
