class TBMiddleData {
  final String titleText;
  final String subtitleText;

  const TBMiddleData({
    this.titleText,
    this.subtitleText,
  });

  factory TBMiddleData.title(String text) =>
      text != null ? TBMiddleData(titleText: text) : null;

  factory TBMiddleData.condensed(String title, String subtitle) =>
      title != null && subtitle != null
          ? TBMiddleData(titleText: title, subtitleText: subtitle)
          : null;
}
