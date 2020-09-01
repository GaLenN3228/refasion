import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class SearchButton extends StatelessWidget {
  final Function onTap;

  const SearchButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Container(
          height: 46,
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              shadows: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                  color: Colors.black.withOpacity(0.15),
                )
              ]),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SVGIcon(
                icon: IconAsset.search,
                size: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  "Искать по адресу",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
