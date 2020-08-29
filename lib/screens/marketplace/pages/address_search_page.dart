import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class AddressSearchPage extends StatelessWidget {
  final Function(Address) onSelect;

  const AddressSearchPage({Key key, this.onSelect}) : super(key: key);
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
              data: TopBarData.sellerPage(
                titleText: "Поиск",
                rightAction: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onSelect(null);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Результаты поиска",
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
