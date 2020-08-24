import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/utils/colors.dart';

class TBButton extends StatelessWidget {
  final TBButtonData data;

  final noneButton = SizedBox(
    width: 4,
  );

  TBButton({Key key, this.data}) : super(key: key);

  asset() {
    switch (data.icon) {
      case TBIconType.back:
        return "assets/topbar/svg/back_44dp.svg";
      case TBIconType.share:
        return "assets/topbar/svg/share_44dp.svg";
      case TBIconType.favorites_checked:
        return "assets/topbar/svg/favorite_red_44dp.svg";
      case TBIconType.favorites_unchecked:
        return "assets/topbar/svg/favorite_border_44dp.svg";
      case TBIconType.filters:
        return "assets/topbar/svg/filters_44dp.svg";
      case TBIconType.setttings:
        return "assets/topbar/svg/settings_44dp.svg";
      case TBIconType.search:
        return "assets/topbar/svg/search_44dp.svg";
      case TBIconType.wardrobe:
        return "assets/topbar/svg/hanger_44dp.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (data.type) {
      case TBButtonType.text:
        if (data.text == null || data.text.isEmpty || data.align == null)
          return noneButton;

        EdgeInsets padding;
        TextAlign textAlign;
        Alignment alignment;

        switch (data.align) {
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
          onTap: data.onTap != null ? data.onTap : () {},
          child: Container(
            padding: padding,
            alignment: alignment,
            child: Text(
              data.text,
              textAlign: textAlign,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: data.textColor ?? darkGrayColor),
            ),
          ),
        );

      case TBButtonType.icon:
        if (data.icon == null || data.align == null) return noneButton;

        EdgeInsets padding;
        Alignment alignment;

        switch (data.align) {
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
          onTap: data.onTap != null ? data.onTap : () {},
          child: Container(
            alignment: alignment,
            padding: padding,
            child: SvgPicture.asset(
              asset(),
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
