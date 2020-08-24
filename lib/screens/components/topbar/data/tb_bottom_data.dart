enum TBBottomType { search, header, headerAndSearch, none }

class TBBottomData {
  final TBBottomType type;
  final String headerText;

  final String searchHintText;
  final Function(String) onSearchUpdate;
  final Function() onSearchFocus;
  final Function() onSearchUnfocus;

  const TBBottomData(
      {this.type,
      this.headerText,
      this.onSearchUpdate,
      this.searchHintText,
      this.onSearchFocus,
      this.onSearchUnfocus})
      : assert(type != null);

  factory TBBottomData.none() => TBBottomData(type: TBBottomType.none);
}
