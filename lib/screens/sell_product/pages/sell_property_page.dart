import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/screens/sell_product/components/header.dart';
import 'package:refashioned_app/screens/sell_product/components/sell_property_values_list.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class SellPropertyPage extends StatefulWidget {
  final SellProperty sellProperty;
  final Function() onPush;
  final Function() onClose;

  const SellPropertyPage(
      {Key key, this.sellProperty, this.onPush, this.onClose})
      : super(key: key);

  @override
  _SellPropertyPageState createState() => _SellPropertyPageState();
}

class _SellPropertyPageState extends State<SellPropertyPage> {
  final isScrolled = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SellPropertyValuesList(
          values: widget.sellProperty.values,
          bottomPadding: 10,
          isScrolled: isScrolled,
          appBar: SellProductTopBar(
            TopBarType.addItem,
            onClose: widget.onClose,
          ),
          header: Header(
            text: widget.sellProperty.header,
            isScrolled: isScrolled,
          ),
          multiselection: widget.sellProperty.multiselection,
          onUpdate: (id) {
            setState(() {
              widget.sellProperty.update(id);
            });
            if (widget.onPush != null && !widget.sellProperty.multiselection)
              widget.onPush();
          },
          onPush: () {
            if (widget.onPush != null) widget.onPush();
          }),
    );
  }
}
