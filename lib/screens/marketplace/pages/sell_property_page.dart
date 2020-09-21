import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/marketplace/components/sell_property_values_list.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class SellPropertyPage extends StatefulWidget {
  final List<SellProperty> initialData;
  final SellProperty sellProperty;

  final Function() onClose;
  final Function() onUpdate;
  final Function() onPush;

  const SellPropertyPage(
      {this.sellProperty,
      this.onPush,
      this.onClose,
      this.onUpdate,
      this.initialData})
      : assert(sellProperty != null);

  @override
  _SellPropertyPageState createState() => _SellPropertyPageState();
}

class _SellPropertyPageState extends State<SellPropertyPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: SellPropertyValuesList(
          values: widget.sellProperty.values,
          bottomPadding: 100,
          appBar: RefashionedTopBar(
            data: TopBarData.simple(
              onBack: () => Navigator.of(context).pop(),
              middleText: "Добавить вещь",
              onClose: widget.onClose,
              bottomText: widget.sellProperty.header,
            ),
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
