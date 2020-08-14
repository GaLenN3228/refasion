import 'package:flutter/material.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/sell_product/components/sell_property_value_tile.dart';

class SellPropertyValuesList extends StatefulWidget {
  final Widget header;
  final Widget appBar;
  final List<SellPropertyValue> values;
  final Function(String) onUpdate;
  final Function() onPush;
  final bool multiselection;
  final double bottomPadding;
  final ScrollController scrollController;

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  const SellPropertyValuesList({
    Key key,
    this.onUpdate,
    this.multiselection: false,
    this.bottomPadding: 0.0,
    this.values,
    this.header,
    this.appBar,
    this.scrollController,
    this.animation,
    this.secondaryAnimation,
    this.onPush,
  }) : super(key: key);

  @override
  _SellPropertyValuesListState createState() => _SellPropertyValuesListState();
}

class _SellPropertyValuesListState extends State<SellPropertyValuesList> {
  @override
  Widget build(BuildContext context) {
    final widgets = widget.values
        .map(
          (value) => SellPropertyValueTile(
            sellPropertyValue: value,
            selected: widget.multiselection ? value.selected : null,
            onPush: () {
              if (widget.onUpdate != null) widget.onUpdate(value.id);
            },
          ),
        )
        .toList();

    return Column(
      children: [
        widget.appBar ?? SizedBox(),
        Expanded(
          child: Column(
            children: [
              widget.header != null ? widget.header : SizedBox(),
              Expanded(
                child: Stack(
                  children: [
                    ListView.separated(
                      controller: widget.scrollController ?? ScrollController(),
                      padding: EdgeInsets.only(
                          top: widget.header != null ? 11 : 0,
                          bottom: MediaQuery.of(context).padding.bottom +
                              widget.bottomPadding),
                      itemCount: widgets.length,
                      itemBuilder: (context, index) => widgets.elementAt(index),
                      separatorBuilder: (context, index) => CategoryDivider(),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: widget.multiselection
                          ? BottomButton(
                              title: "ВЫБРАТЬ",
                              action: widget.onPush,
                            )
                          : SizedBox(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
