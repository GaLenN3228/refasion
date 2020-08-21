import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/sell_product/components/border_button.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/sell_product/pages/new_card_page.dart';
import 'package:refashioned_app/utils/colors.dart';

class CardsPage extends StatelessWidget {
  final String initialData;

  final Function() onClose;
  final Function(String) onUpdate;
  final Function() onPush;

  const CardsPage({this.onPush, this.onClose, this.initialData, this.onUpdate});

  showNewCardPanel(BuildContext context) {
    showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      builder: (context, controller) => NewCardPage(
        onPush: () {},
      ),
    );
  }

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
              headerText: "Выберите банковскую карту",
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onPush,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            "assets/card.svg",
                            width: 32,
                            height: 22,
                            color: primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              "Cписок банковских карт пуст",
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
                              "Укажите банковскую карту для получения денег в случае продажи",
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
                    type: BorderButtonType.newCard,
                    onTap: () => showNewCardPanel(context),
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
