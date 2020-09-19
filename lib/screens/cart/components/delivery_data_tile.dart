import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_data.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class DeliveryDataTile extends StatefulWidget {
  final DeliveryCompany deliveryCompany;
  final DeliveryData deliveryData;
  final Function() onTap;

  const DeliveryDataTile(
      {Key key, this.deliveryData, this.onTap, this.deliveryCompany})
      : super(key: key);

  @override
  _DeliveryDataTileState createState() => _DeliveryDataTileState();
}

class _DeliveryDataTileState extends State<DeliveryDataTile> {
  String text;
  String action;

  bool selected;

  update() {
    if (widget.deliveryCompany == null || widget.deliveryData == null) {
      text = "Выберите способ доставки";
      action = "Выбрать";
      selected = false;
    } else {
      text = deliveryLabels[widget.deliveryCompany.type] +
          " - " +
          widget.deliveryData.text;
      action = "Изменить";
      selected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    update();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: SVGIcon(
                        icon: deliveryIcons[widget.deliveryCompany.type],
                        size: 24,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10),
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: !selected ? Color(0xFF930012) : null,
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
