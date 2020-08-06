import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

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
            child: SellProductTopBar(
              TopBarType.newCard,
              onClose: () => Navigator.of(context).pop(),
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
