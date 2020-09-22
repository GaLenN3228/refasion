import 'package:flutter/material.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/marketplace/components/sell_property_value_tile.dart';

class SellPropertyValuesList extends StatefulWidget {
  final Widget header;
  final Widget appBar;
  final List<SellPropertyValue> values;
  final Function(String) onUpdate;
  final Function() onPush;
  final bool multiselection;
  final double bottomPadding;
  final ScrollController scrollController;
  final required;

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
    this.required,
  }) : super(key: key);

  @override
  _SellPropertyValuesListState createState() => _SellPropertyValuesListState();
}

class _SellPropertyValuesListState extends State<SellPropertyValuesList> {
  @override
  Widget build(BuildContext context) {
    final isPropertiesListEmpty = widget.values.where((element) => element.selected).isEmpty;
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
                          bottom: MediaQuery.of(context).padding.bottom + widget.bottomPadding),
                      itemCount: widgets.length,
                      itemBuilder: (context, index) => widgets.elementAt(index),
                      separatorBuilder: (context, index) => ItemsDivider(),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: widget.multiselection
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Button(
                                "ВЫБРАТЬ",
                                buttonStyle: !isPropertiesListEmpty && widget.required
                                    ? ButtonStyle.dark
                                    : ButtonStyle.dark_gray,
                                height: 45,
                                width: double.infinity,
                                borderRadius: 5,
                                onClick: !isPropertiesListEmpty && widget.required
                                    ? () {
                                        widget.onPush();
                                      }
                                    : () {},
                              ))
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
