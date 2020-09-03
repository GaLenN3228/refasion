class TBBottomData {
  final String headerText;

  const TBBottomData({this.headerText});

  factory TBBottomData.header(String text) =>
      text != null ? TBBottomData(headerText: text) : null;
}
