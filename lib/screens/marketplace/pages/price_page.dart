import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_price_formatter.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/marketplace/components/price_button.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:provider/provider.dart';

class PricePage extends StatefulWidget {
  final int initialData;

  final Function() onClose;
  final Function(int) onUpdate;
  final Function() onPush;

  final FocusNode focusNode;

  const PricePage({this.onPush, this.onClose, this.focusNode, this.initialData, this.onUpdate});

  @override
  _PricePageState createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> with WidgetsBindingObserver {
  TextEditingController textController;
  Map<PriceButtonType, int> prices;
  PriceFormatter priceFormatter;

  final double bottomPadding = 16;

  bool canPush;
  bool keyboardVisible;

  CalcProductPrice _calcProductPrice;

  int newPrice;

  @override
  void initState() {
    priceFormatter = PriceFormatter();

    textController = TextEditingController(
        text: widget.initialData != null
            ? priceFormatter.format(widget.initialData.toString())
            : null);
    prices = {PriceButtonType.tradeIn: 0, PriceButtonType.diy: 0};

    textController.text = "";
    textController.addListener(textControllerListener);

    canPush = false;
    keyboardVisible = false;

    _calcProductPrice = Provider.of<CalcProductPrice>(context, listen: false);
    _calcProductPrice.addListener(() {
      var price = 0;
      if (_calcProductPrice.isLoaded ||
          (_calcProductPrice.isLoading && _calcProductPrice.response != null)) {
        price = _calcProductPrice.response.content.cash;
      } else {
        _calcProductPrice.response = null;
      }

      widget.onUpdate(newPrice);

      setState(() {
        canPush = price != 0;

        prices = {PriceButtonType.tradeIn: price, PriceButtonType.diy: price};
      });
    });

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    textController.removeListener(textControllerListener);

    textController.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  textControllerListener() {
    newPrice = int.tryParse(priceFormatter.plainText(textController.text)) ?? 0;
    _calcProductPrice.calcProductPrice(newPrice);
  }

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
    final keyboardTopPixels = window.physicalSize.height - window.viewInsets.bottom;
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
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RefashionedTopBar(
            data: TopBarData.simple(
              onBack: () => Navigator.of(context).pop(),
              middleText: "Добавить вещь",
              onClose: widget.onClose,
              bottomText: "Укажите цену",
            ),
          ),
          Expanded(
            child: Padding(
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
                          focusNode: widget.focusNode,
                          autofocus: true,
                          style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20),
                          cursorWidth: 2.0,
                          cursorRadius: Radius.circular(2.0),
                          cursorColor: Color(0xFFE6E6E6),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFE6E6E6), width: 1)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFE6E6E6), width: 1)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFE6E6E6), width: 1)),
                            hintText: "   ₽",
                            hintStyle: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SVGIcon(
                          icon: IconAsset.info,
                          size: 22,
                        ),
                        SizedBox(
                          width: 4,
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
                  ),
                  PriceButton(
                    type: PriceButtonType.diy,
                    prices: prices,
                    onPush: () => widget.onPush(),
                  ),
                ],
              ),
            ),
          ),
          BottomButton(
            title: "Продолжить".toUpperCase(),
            enabled: canPush,
            action: () => widget.onPush(),
          ),
          AnimatedContainer(
            height: keyboardVisible ? bottomPadding : 0,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
