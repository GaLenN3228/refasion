import 'dart:ui';

enum TBButtonType { text, icon, none }

enum TBButtonAlign { left, right }

enum TBIconType { back, share, favorites_checked, favorites_unchecked, filters, setttings, search, wardrobe }

class TBButtonData {
  final TBButtonType type;

  final TBButtonAlign align;

  final Function() onTap;

  final String text;
  final Color textColor;

  final TBIconType icon;
  final Color iconColor;

  const TBButtonData(
      {this.type,
      this.align,
      this.onTap,
      this.text,
      this.icon,
      this.textColor,
      this.iconColor})
      : assert(type != null && align != null || type == TBButtonType.none);

  factory TBButtonData.none() => TBButtonData(type: TBButtonType.none);

  factory TBButtonData.back({Function() onTap}) => TBButtonData(
        type: TBButtonType.icon,
        align: TBButtonAlign.left,
        icon: TBIconType.back,
        onTap: onTap ?? () {},
      );

  factory TBButtonData.close({Function() onTap}) => TBButtonData(
        type: TBButtonType.text,
        align: TBButtonAlign.right,
        text: "Закрыть",
        onTap: onTap ?? () {},
      );

  factory TBButtonData.right(
          {TBButtonType type,
          Function() onTap,
          String text,
          TBIconType icon,
          Color textColor,
          Color iconColor}) =>
      TBButtonData(
          type: type,
          align: TBButtonAlign.right,
          text: text,
          onTap: onTap,
          icon: icon,
          textColor: textColor,
          iconColor: iconColor);
}
