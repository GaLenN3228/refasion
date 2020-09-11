import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class CheckoutPage extends StatefulWidget {
  final Function() onClose;

  const CheckoutPage({Key key, this.onClose}) : super(key: key);
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.simple(
              middleText: "Оформление заказа",
              onBack: Navigator.of(context).pop,
              onClose: widget.onClose,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Данные заказа",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
