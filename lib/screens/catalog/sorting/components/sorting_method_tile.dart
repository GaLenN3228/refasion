import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/models/sort.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                ? Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: SvgPicture.asset(
                      "assets/small_done.svg",
                      height: 12,
                      color: Colors.black,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
