import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/utils/colors.dart';

class TBButton extends StatelessWidget {
  final TBButtonData data;
  final EdgeInsets padding;

  const TBButton({Key key, this.data, this.padding: EdgeInsets.zero})
      : super(key: key);

  IconAsset asset() {
    switch (data.iconType) {
      case TBIconType.back:
        return IconAsset.back;
      case TBIconType.share:
        return IconAsset.share;
      case TBIconType.favorites:
        return IconAsset.favoriteBorder;
      case TBIconType.filters:
        return IconAsset.filters;
      case TBIconType.setttings:
        return IconAsset.settingsRounded;
      case TBIconType.search:
        return IconAsset.search;
      case TBIconType.hanger:
        return IconAsset.hanger;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data?.label != null)
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: data.onTap != null ? data.onTap : () {},
        child: Padding(
          padding: padding,
          child: Text(
            data.label,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: data.textColor ?? darkGrayColor),
          ),
        ),
      );
    else if (data?.iconType != null)
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: data.onTap != null ? data.onTap : () {},
        child: Padding(
          padding: padding,
          child: SVGIcon(icon: asset()),
        ),
      );
    else
      return SizedBox();
  }
}
