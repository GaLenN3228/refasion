class TBSearchData {
  final String hintText;
  final Function(String) onSearchUpdate;
  final Function() onFocus;
  final Function() onUnfocus;
  final bool autofocus;

  const TBSearchData({
    this.onSearchUpdate,
    this.hintText,
    this.onFocus,
    this.onUnfocus,
    this.autofocus: false,
  });
}
