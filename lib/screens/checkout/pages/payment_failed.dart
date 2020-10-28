import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class PaymentFailedPage extends StatelessWidget {
  final int totalPrice;
  final Function() onClose;

  const PaymentFailedPage({Key key, this.totalPrice, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,###", "ru_Ru");

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          RefashionedTopBar(
            data: TopBarData.simple(
              middleText: "Оформление заказа",
              onBack: Navigator.of(context).pop,
              onClose: onClose,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 65.0 + 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SVGIcon(
                      icon: IconAsset.paymentFailed,
                      size: 48,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "Оплата не прошла",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                    child: Text(
                      "Что-то пошло не так",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(color: primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Сумма заказа ${numberFormat.format(totalPrice)} ₽",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: Navigator.of(context).pop,
                    child: Container(
                      width: 140,
                      height: 35,
                      decoration: ShapeDecoration(
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Вернуться".toUpperCase(),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
