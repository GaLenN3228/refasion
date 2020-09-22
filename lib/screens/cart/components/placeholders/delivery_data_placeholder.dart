import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class DeliveryDataPlaceholder extends StatefulWidget {
  @override
  _DeliveryDataPlaceholderState createState() => _DeliveryDataPlaceholderState();
}

class _DeliveryDataPlaceholderState extends State<DeliveryDataPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: SVGIcon(
                    icon: IconAsset.add,
                    size: 24,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: Text(
                      "text",
                      style: Theme.of(context).textTheme.subtitle1,
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
                "action",
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
    );
  }
}
