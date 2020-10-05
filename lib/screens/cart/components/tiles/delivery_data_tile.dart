import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_data.dart';
import 'package:refashioned_app/models/cart/delivery_option.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class DeliveryDataTile extends StatefulWidget {
  final DeliveryOption deliveryOption;
  final DeliveryData deliveryData;
  final bool available;

  final Function() onTap;

  const DeliveryDataTile({
    Key key,
    this.deliveryData,
    this.onTap,
    this.deliveryOption,
    this.available,
  }) : super(key: key);

  @override
  _DeliveryDataTileState createState() => _DeliveryDataTileState();
}

class _DeliveryDataTileState extends State<DeliveryDataTile> {
  String text;
  String action;
  IconAsset icon;

  bool selected;

  update() {
    text = null;
    action = null;
    icon = null;
    selected = false;

    if (widget.deliveryOption == null || widget.deliveryData == null) {
      text = "Выберите способ доставки";
      action = "Выбрать";
      selected = false;
    } else {
      final type = widget.deliveryOption.deliveryCompany.type;

      icon = deliveryIcons[type];
      text = deliveryLabels[type] + " - " + widget.deliveryData.text.toLowerCase();
      action = "Изменить";
      selected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.available) return SizedBox();

    update();

    if (text == null || action == null) return SizedBox();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.available) widget.onTap?.call();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: SVGIcon(
                        icon: icon,
                        size: 24,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10),
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: !selected ? red : null,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  action,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                RotatedBox(
                  quarterTurns: 2,
                  child: SVGIcon(
                    icon: IconAsset.back,
                    size: 14,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
