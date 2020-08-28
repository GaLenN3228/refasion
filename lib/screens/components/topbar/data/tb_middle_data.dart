class TBMiddleData {
  final String titleText;
  final String subtitleText;

  const TBMiddleData({
    this.titleText,
    this.subtitleText,
  });

  factory TBMiddleData.none() => TBMiddleData();

  factory TBMiddleData.title(String text) => TBMiddleData(titleText: text);

  factory TBMiddleData.condensed(String title, String subtitle) =>
      TBMiddleData(titleText: title, subtitleText: subtitle);
}
