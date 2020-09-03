import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class NewCardPage extends StatelessWidget {
  final Function() onPush;

  const NewCardPage({Key key, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 5),
            child: RefashionedTopBar(
              data: TopBarData.simple(
                middleText: "Новая карта",
                onBack: () => Navigator.of(context).pop(),
              ),
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
