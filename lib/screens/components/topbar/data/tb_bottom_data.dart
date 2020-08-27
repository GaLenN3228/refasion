class TBBottomData {
  final String headerText;

  const TBBottomData({this.headerText});

  factory TBBottomData.none() => TBBottomData();

  factory TBBottomData.header(String text) => TBBottomData(headerText: text);
}
