import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/utils/colors.dart';

final _assets = {
  TBIconType.back: IconAsset.back,
  TBIconType.share: IconAsset.share,
  TBIconType.favorite: IconAsset.favoriteBorder,
  TBIconType.favoriteFilled: IconAsset.favoriteFilled,
  TBIconType.filters: IconAsset.filters,
  TBIconType.setttings: IconAsset.settingsRounded,
  TBIconType.search: IconAsset.search,
  TBIconType.hanger: IconAsset.hanger
};

class TBButton extends StatefulWidget {
  final TBButtonData data;
  final EdgeInsets padding;
  final Alignment alignment;

  const TBButton({Key key, this.data, this.padding: EdgeInsets.zero, this.alignment}) : super(key: key);

  @override
  _TBButtonState createState() => _TBButtonState();
}

class _TBButtonState extends State<TBButton> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  initState() {
    if (widget.data != null && widget.data.animated) {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data?.label != null)
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.data.onTap?.call,
        child: Container(
          padding: widget.padding,
          alignment: widget.alignment,
          height: double.infinity,
          child: Text(
            widget.data.label,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: widget.data.textColor ?? darkGrayColor,
                ),
          ),
        ),
      );
    else if (widget.data?.iconType != null) {
      final asset = _assets[widget.data.iconType];

      final icon = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          await widget.data.onTap?.call();

          if (widget.data.animated) {
            await animationController?.forward();
            await animationController?.reverse();
          }
        },
        child: Container(
          height: double.infinity,
          alignment: widget.alignment,
          padding: widget.data.animated
              ? EdgeInsets.fromLTRB(
                  widget.padding.left / 1.2,
                  widget.padding.top / 1.2,
                  widget.padding.right / 1.2,
                  widget.padding.bottom / 1.2,
                )
              : widget.padding,
          child: SVGIcon(
            icon: asset,
            color: widget.data.iconColor,
          ),
        ),
      );

      if (widget.data.animated) {
        return ScaleTransition(
          scale: animationController.drive(Tween<double>(begin: 1.0, end: 1.2)),
          child: icon,
        );
      }

      return icon;
    } else
      return SizedBox();
  }
}
