import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class OnModerationPage extends StatelessWidget {
  final Function() onClose;

  const OnModerationPage({Key key, this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          SellProductTopBar(
            TopBarType.onModeration,
            onClose: onClose,
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
