import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/cart/delivery/components/delivery_option_tile.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
import 'package:refashioned_app/screens/catalog/filters/components/sliding_panel_indicator.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class DeliveryOptionsPanel extends StatelessWidget {
  final List<DeliveryOptionData> options;
  final Function(DeliveryType) onPush;

  const DeliveryOptionsPanel({Key key, this.options, this.onPush})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...[
              SlidingPanelIndicator(),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: RefashionedTopBar(
                  data: TopBarData.simple(
                    middleText: "Способ доставки",
                    includeTopScreenPadding: false,
                  ),
                ),
              ),
            ],
            ...options
                .asMap()
                .map((index, option) => MapEntry(
                    index,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DeliveryOptionTile(
                          data: options.elementAt(index),
                          onPush: onPush,
                        ),
                        if (index != options.length - 1) ItemsDivider(),
                      ],
                    )))
                .values
                .toList()
          ],
        ),
      ),
    );
  }
}
