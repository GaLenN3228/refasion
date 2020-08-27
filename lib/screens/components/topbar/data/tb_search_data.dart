class TBSearchData {
  final String hintText;

  final Function(String) onSearchUpdate;

  final bool autofocus;

  Function() _onFocus;
  Function() _onUnfocus;

  TBSearchData({
    this.onSearchUpdate,
    this.hintText,
    this.autofocus: false,
  });

  setFunctions(Function() onFocus, Function() onUnfocus) {
    _onFocus = onFocus;
    _onUnfocus = onUnfocus;
  }

  Function() get onFocus => _onFocus ?? () {};

  Function() get onUnfocus => _onUnfocus ?? () {};
}
