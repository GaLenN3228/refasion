import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashioned_app/utils/colors.dart';

enum TBButtonType { text, icon, none }

enum TBButtonAlign { left, right }

enum TBIconType { back, share, favorites, filters, setttings, search, wardrobe }

class TBButton extends StatelessWidget {
  final TBButtonType type;

  final TBButtonAlign align;

  final Function() onTap;

  final String text;
  final Color textColor;

  final TBIconType icon;
  final Color iconColor;

  TBButton(this.type, this.align,
      {Key key,
      this.onTap,
      this.text,
      this.icon,
      this.textColor,
      this.iconColor})
      : super(key: key);

  final noneButton = SizedBox(
    width: 4,
  );

  asset() {
    switch (icon) {
      case TBIconType.back:
        return "assets/back.svg";
      case TBIconType.share:
        return "assets/share.svg";
      case TBIconType.favorites:
        return "assets/favorites.svg";
      case TBIconType.filters:
        return "assets/filters.svg";
      case TBIconType.setttings:
        return "assets/settings.svg";
      case TBIconType.search:
        return "assets/search.svg";
      case TBIconType.wardrobe:
        return "assets/wardrobe.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TBButtonType.text:
        if (text == null || text.isEmpty || align == null) return noneButton;

        EdgeInsets padding;
        TextAlign textAlign;
        Alignment alignment;

        switch (align) {
          case TBButtonAlign.left:
            padding = const EdgeInsets.only(left: 20, right: 10);
            alignment = Alignment.centerLeft;
            textAlign = TextAlign.left;
            break;
          case TBButtonAlign.right:
            padding = const EdgeInsets.only(left: 10, right: 20);
            alignment = Alignment.centerRight;
            textAlign = TextAlign.right;
            break;
        }

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap != null ? onTap : () {},
          child: Container(
            padding: padding,
            alignment: alignment,
            child: Text(
              text,
              textAlign: textAlign,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: textColor ?? darkGrayColor),
            ),
          ),
        );

      case TBButtonType.icon:
        if (icon == null || align == null) return noneButton;

        EdgeInsets padding;
        Alignment alignment;

        switch (align) {
          case TBButtonAlign.left:
            padding = const EdgeInsets.only(left: 4, right: 2);
            alignment = Alignment.centerLeft;
            break;
          case TBButtonAlign.right:
            padding = const EdgeInsets.only(left: 2, right: 4);
            alignment = Alignment.centerRight;
            break;
        }

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap != null ? onTap : () {},
          child: Container(
            alignment: alignment,
            padding: padding,
            child: SvgPicture.asset(
              asset(),
              color: Colors.black,
              width: 44,
              height: 44,
            ),
          ),
        );

      default:
        return noneButton;
    }
  }
}
