import 'package:flutter/material.dart';
import 'package:refashioned_app/models/sort.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class SortMethodTile extends StatelessWidget {
  final SortMethod method;
  final Function() onSelect;

  const SortMethodTile(this.method, this.onSelect);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 15, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              method.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            method.selected
                ? SVGIcon(
                    icon: IconAsset.done,
                    size: 26,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
