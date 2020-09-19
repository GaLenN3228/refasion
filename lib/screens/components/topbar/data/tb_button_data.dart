import 'dart:ui';

enum TBIconType {
  back,
  share,
  favorite,
  favoriteFilled,
  filters,
  setttings,
  search,
  hanger
}

class TBButtonData {
  final Function() onTap;

  final String label;
  final Color textColor;

  final TBIconType iconType;
  final Color iconColor;

  final bool animated;

  const TBButtonData(
      {this.animated: false,
      this.onTap,
      this.label,
      this.iconType,
      this.textColor,
      this.iconColor});

  factory TBButtonData.icon(TBIconType icon,
          {Function() onTap, Color color, bool animated}) =>
      icon != null
          ? TBButtonData(
              iconType: icon,
              onTap: onTap,
              iconColor: color,
              animated: animated ?? false)
          : null;

  factory TBButtonData.text(String label, {Function() onTap, Color color}) =>
      label != null ? TBButtonData(label: label, onTap: onTap) : null;
}
