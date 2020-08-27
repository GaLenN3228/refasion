import 'package:refashioned_app/models/status.dart';

class SortMethodsResponse {
  final Status status;
  final Sort content;

  const SortMethodsResponse({this.status, this.content});

  factory SortMethodsResponse.fromJson(Map<String, dynamic> json) {
    return SortMethodsResponse(
      status: Status.fromJson(json['status']),
      content: Sort.fromJson(json['content'] ?? []),
    );
  }
}

class Sort {
  final List<SortMethod> methods;

  bool _modified = false;
  bool get modified => _modified;

  int _defaultIndex = 0;

  int _index = 0;
  int get index => _index;

  Sort(this.methods, this._defaultIndex, this._index);

  factory Sort.fromJson(List<dynamic> json) {
    int newDefaultIndex = 0;

    final methods = [
      for (final sortMethod in json) SortMethod.fromJson(sortMethod)
    ];

    methods.elementAt(newDefaultIndex).selected = true;

    return Sort(methods, newDefaultIndex, newDefaultIndex);
  }

  isModified() => _modified = _index != _defaultIndex;

  update(String value) {
    if (value != null && value.isNotEmpty) {
      methods.forEach((method) => method.selected = method.value == value);
      _index = methods.indexWhere((method) => method.selected);
    }

    isModified();
  }

  reset() {
    methods
        .asMap()
        .entries
        .forEach((entry) => entry.value.selected = entry.key == _defaultIndex);

    _index = _defaultIndex;

    isModified();
  }

  String getRequestParameters() {
    if (!_modified) return "";

    final selectedValue =
        methods.firstWhere((method) => method.selected).value ?? '';

    if (selectedValue.isNotEmpty)
      return "&sort=" + selectedValue;
    else
      return "";
  }
}

class SortMethod {
  final String name;
  final String value;

  bool selected;

  SortMethod({this.name, this.value, this.selected: false});

  factory SortMethod.fromJson(Map<String, dynamic> json) =>
      SortMethod(name: json['name'], value: json['value']);

  factory SortMethod.clone(SortMethod other) => SortMethod(
      name: other.name, value: other.value, selected: other.selected);

  update() {
    selected = !selected;
  }

  reset() {
    selected = false;
  }

  @override
  String toString() =>
      "Sort Method: " + name + ", selected: " + selected.toString();
}
