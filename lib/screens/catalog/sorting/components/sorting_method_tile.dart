import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SortMethodTile extends StatelessWidget {
  final String method;
  final bool selected;

  const SortMethodTile({Key key, this.method, this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            method,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w500),
          ),
          selected
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
    );
  }
}
