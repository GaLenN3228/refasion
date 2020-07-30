import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/sell_product/components/header.dart';
import 'package:refashioned_app/screens/sell_product/components/price_button.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class PricePage extends StatefulWidget {
  final Function(int) onPush;

  const PricePage({Key key, this.onPush}) : super(key: key);

  @override
  _PricePageState createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> with WidgetsBindingObserver {
  final double bottomPadding = 16;

  TextEditingController textEditingController;
  bool canPush;
  bool keyboardVisible;
  Map<PriceButtonType, int> prices;

  @override
  void initState() {
    textEditingController = TextEditingController();
    canPush = false;
    keyboardVisible = false;
    prices = {PriceButtonType.tradeIn: 0, PriceButtonType.diy: 0};

    textEditingController.addListener(textControllerListener);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  textControllerListener() {
    if (int.tryParse(textEditingController.text) != null) {
      final newPrice = int.parse(textEditingController.text);
      setState(() => prices = {
            PriceButtonType.tradeIn: (newPrice * 0.7).round(),
            PriceButtonType.diy: (newPrice * 0.85).round()
          });
    } else {
      setState(
          () => prices = {PriceButtonType.tradeIn: 0, PriceButtonType.diy: 0});
    }
  }

  @override
  void dispose() {
    textEditingController.removeListener(textControllerListener);

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //Метод определения высоты клавиатуры: https://medium.com/flutter-nyc/avoiding-the-on-screen-keyboard-in-flutter-ae0e46ecb96c

  // @override
  // void didChangeMetrics() {
  //   final renderObject = context.findRenderObject();
  //   final renderBox = renderObject as RenderBox;
  //   final offset = renderBox.localToGlobal(Offset.zero);
  //   final widgetRect = Rect.fromLTWH(
  //     offset.dx,
  //     offset.dy,
  //     renderBox.size.width,
  //     renderBox.size.height,
  //   );
  //   final keyboardTopPixels =
  //       window.physicalSize.height - window.viewInsets.bottom;
  //   final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
  //   final overlap = widgetRect.bottom - keyboardTopPoints;
  //   print("Overlap: " + overlap.toString());

  //   if (overlap > 200) {
  //     setState(() => bottomOverlap = overlap + bottomPadding);
  //     print("Bottom Overlap: " + bottomOverlap.toString() + "\n\n");
  //   } else if (overlap == 0) {
  //     setState(() => bottomOverlap = 0);
  //     print("Bottom Overlap: " + bottomOverlap.toString() + "\n\n");
  //   }
  // }

  void didChangeMetrics() {
    final renderObject = context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final overlap = widgetRect.bottom - keyboardTopPoints;

    setState(() {
      keyboardVisible = overlap > 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SellProductTopBar(),
          Header(
            text: "Укажите цену",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 22, bottom: 10),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: textEditingController,
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
                          hintText: "0",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 20),
                          suffixText: " ₽"),
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
