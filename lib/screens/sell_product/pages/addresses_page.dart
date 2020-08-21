import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/sell_product/components/border_button.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class AddressesPage extends StatelessWidget {
  final String initialData;

  final Function() onClose;
  final Function(String) onUpdate;
  final Function() onPush;
  final Function() onSkip;

  const AddressesPage(
      {this.onPush,
      this.onClose,
      this.onSkip,
      this.initialData,
      this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          RefashionedTopBar(
            data: TopBarData.sellerPage(
              leftAction: () => Navigator.of(context).pop(),
              titleText: "Добавить вещь",
              rightAction: onClose,
              headerText: "Укажите адрес",
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onSkip,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: 32,
                            height: 22,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              "Cписок адресов пуст",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            width: 230,
                            child: Text(
                              "Укажите удобное вам место встречи с покупателем",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: BorderButton(
                    type: BorderButtonType.newAddress,
                    onTap: onPush,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
