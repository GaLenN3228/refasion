enum TBMiddleType { title, condensed, search, none }

class TBMiddleData {
  final TBMiddleType type;
  final String titleText;
  final String subtitleText;

  const TBMiddleData({
    this.type,
    this.titleText,
    this.subtitleText,
  }) : assert(type != null);

  factory TBMiddleData.none() => TBMiddleData(type: TBMiddleType.none);

  factory TBMiddleData.title(String text) => TBMiddleData(
        type: TBMiddleType.title,
        titleText: text,
      );

  factory TBMiddleData.condensed(String title, String subtitle) => TBMiddleData(
      type: TBMiddleType.condensed, titleText: title, subtitleText: subtitle);
}
