import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/screens/sell_product/components/sell_property_values_list.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class SellPropertyPage extends StatefulWidget {
  final SellProperty sellProperty;
  final Function() onPush;
  final Function() onClose;

  const SellPropertyPage({this.sellProperty, this.onPush, this.onClose})
      : assert(sellProperty != null);

  @override
  _SellPropertyPageState createState() => _SellPropertyPageState();
}

class _SellPropertyPageState extends State<SellPropertyPage> {
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SellPropertyValuesList(
          values: widget.sellProperty.values,
          bottomPadding: 10,
          scrollController: scrollController,
          appBar: RefashionedTopBar(
            leftButtonType: TBButtonType.icon,
            leftButtonIcon: TBIconType.back,
            leftButtonAction: () => Navigator.of(context).pop(),
            middleType: TBMiddleType.title,
            middleTitleText: "Добавить вещь",
            rightButtonType: TBButtonType.text,
            rightButtonText: "Закрыть",
            rightButtonAction: widget.onClose,
            bottomType: TBBottomType.header,
            bootomHeaderText: widget.sellProperty.header,
            scrollController: scrollController,
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
