import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_price_formatter.dart';
import 'package:refashioned_app/utils/colors.dart';

enum PriceType { lower, upper }

class FilterPriceInput extends StatefulWidget {
  final PriceType type;
  final double value;
  final double limit;
  final bool modified;
  final Function(String) onChanged;

  const FilterPriceInput(
      {Key key,
      this.type,
      this.value,
      this.limit,
      this.onChanged,
      this.modified})
      : super(key: key);

  static const _labels = {PriceType.lower: "От", PriceType.upper: "До"};

  @override
  _FilterPriceInputState createState() => _FilterPriceInputState();
}

class _FilterPriceInputState extends State<FilterPriceInput>
    with SingleTickerProviderStateMixin {
  FocusNode focusNode;
  TextEditingController textController;
  PriceFormatter priceFormatter;
  Animation<double> inputOpacity;
  Animation<double> outputOpacity;
  AnimationController animationController;

  @override
  void initState() {
    focusNode = FocusNode();
    textController = TextEditingController();
    priceFormatter = PriceFormatter();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    inputOpacity = Tween(begin: 0.0, end: 1.0).animate(animationController);
    outputOpacity = Tween(begin: 1.0, end: 0.0).animate(animationController);

    focusNode.addListener(focusNodeListener);

    super.initState();
  }

  focusNodeListener() {
    textController.clear();

    if (focusNode.hasFocus)
      animationController.forward();
    else
      animationController.reverse();
  }

  @override
  void dispose() {
    focusNode.removeListener(focusNodeListener);
    focusNode.unfocus();
    focusNode.dispose();

    textController.dispose();

    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            FilterPriceInput._labels[widget.type],
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => focusNode.requestFocus(),
          child: Container(
            width: 135,
            height: 35,
            decoration: ShapeDecoration(
                color: Color(0xFFF6F6F6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                FadeTransition(
                  opacity: inputOpacity,
                  child: TextField(
                    focusNode: focusNode,
                    controller: textController,
                    onSubmitted: (_) => focusNode.unfocus(),
                    onChanged: (text) =>
                        widget.onChanged(priceFormatter.plainText(text)),
                    inputFormatters: [priceFormatter],
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 15),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: outputOpacity,
                  child: Text(
                    (widget.value ?? widget.limit).toInt().toString() + " ₽",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: widget.modified
                            ? primaryColor
                            : primaryColor.withOpacity(0.25)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
