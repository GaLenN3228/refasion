import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_price_formatter.dart';
import 'package:refashioned_app/screens/sell_product/components/price_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class PricePage extends StatefulWidget {
  final Function(int) onPush;
  final Function() onClose;

  const PricePage({this.onPush, this.onClose});

  @override
  _PricePageState createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  TextEditingController textController;
  Map<PriceButtonType, int> prices;
  PriceFormatter priceFormatter;

  @override
  void initState() {
    priceFormatter = PriceFormatter();

    textController = TextEditingController();
    prices = {PriceButtonType.tradeIn: 0, PriceButtonType.diy: 0};

    textController.addListener(textControllerListener);

    super.initState();
  }

  @override
  void dispose() {
    textController.removeListener(textControllerListener);

    super.dispose();
  }

  textControllerListener() {
    final newPrice =
        int.tryParse(priceFormatter.plainText(textController.text)) ?? 0;
    setState(() => prices = {
          PriceButtonType.tradeIn: (newPrice * 0.7).round(),
          PriceButtonType.diy: (newPrice * 0.85).round()
        });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RefashionedTopBar(
            leftButtonType: TBButtonType.icon,
            leftButtonIcon: TBIconType.back,
            leftButtonAction: () => Navigator.of(context).pop(),
            middleType: TBMiddleType.title,
            middleTitleText: "Добавить вещь",
            rightButtonType: TBButtonType.text,
            rightButtonText: "Закрыть",
            rightButtonAction: widget.onClose,
            bottomType: TBBottomType.header,
            bootomHeaderText: "Укажите цену",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Material(
                  color: Colors.white,
                  child: SizedBox(
                    width: 100,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22, bottom: 10),
                      child: TextField(
                        inputFormatters: [priceFormatter],
                        textAlign: TextAlign.center,
                        controller: textController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontSize: 20),
                        cursorWidth: 2.0,
                        cursorRadius: Radius.circular(2.0),
                        cursorColor: Color(0xFFE6E6E6),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 10),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFE6E6E6), width: 1)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFE6E6E6), width: 1)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFE6E6E6), width: 1)),
                          hintText: "0 ₽",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/info.svg',
                      width: 15,
                      height: 15,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "Как рассчитывается стоимость вещи?",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Выберите формат размещения",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PriceButton(
                  type: PriceButtonType.tradeIn,
                  prices: prices,
                  onPush: widget.onPush,
                ),
                PriceButton(
                  type: PriceButtonType.diy,
                  prices: prices,
                  onPush: widget.onPush,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
