import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class AddressesPage extends StatelessWidget {
  final Function() onPush;
  final Function() onClose;

  const AddressesPage({Key key, this.onPush, this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          SellProductTopBar(
            TopBarType.addItem,
            onClose: onClose,
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onPush,
                  child: Text(
                    "Адреса",
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
