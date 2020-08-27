import 'dart:ui';

enum TBIconType { back, share, favorites, filters, setttings, search, hanger }

class TBButtonData {
  final Function() onTap;

  final String label;
  final Color textColor;

  final TBIconType iconType;
  final Color iconColor;

  const TBButtonData(
      {this.onTap, this.label, this.iconType, this.textColor, this.iconColor});

  factory TBButtonData.icon(TBIconType icon, {Function() onTap, Color color}) =>
      TBButtonData(iconType: icon, onTap: onTap ?? () {}, iconColor: color);

  factory TBButtonData.text(String label, {Function() onTap, Color color}) =>
      TBButtonData(label: label, onTap: onTap ?? () {});
}
