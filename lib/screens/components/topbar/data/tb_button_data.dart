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

  const TBButtonData(
      {this.onTap, this.label, this.iconType, this.textColor, this.iconColor});

  factory TBButtonData.icon(TBIconType icon, {Function() onTap, Color color}) =>
      icon != null
          ? TBButtonData(
              iconType: icon, onTap: onTap ?? () {}, iconColor: color)
          : null;

  factory TBButtonData.text(String label, {Function() onTap, Color color}) =>
      label != null ? TBButtonData(label: label, onTap: onTap ?? () {}) : null;
}
