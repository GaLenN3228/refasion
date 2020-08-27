import 'package:flutter/material.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/screens/catalog/filters/components/selection_mark.dart';

class SellPropertyValueTile extends StatelessWidget {
  final SellPropertyValue sellPropertyValue;
  final Function() onPush;
  final bool selected;

  const SellPropertyValueTile(
      {Key key, this.sellPropertyValue, this.onPush, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPush,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 50,
          alignment: Alignment.centerLeft,
          child: selected == null
              ? Text(
                  sellPropertyValue.value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w500),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      sellPropertyValue.value,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SelectionMark(
                      selected: selected,
                    )
                  ],
                )),
    );
  }
}
