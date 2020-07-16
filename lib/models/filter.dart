import 'package:refashioned_app/models/status.dart';

class FiltersResponse {
  final Status status;
  final List<Filter> content;

  const FiltersResponse({this.status, this.content});

  factory FiltersResponse.fromJson(Map<String, dynamic> json) {
    return FiltersResponse(
        status: Status.fromJson(json['status']),
        content: [if (json['content'] != null) for (final filter in json['content']) Filter.fromJson(filter)]);
  }
}

class Filter {
  static const COLOR = "Цвет";
  static const MATERIAL = "Материал";
  static const PRICE = "Цена";
  static const CONDITION = "Состояние";
  static const SIZE = "Размер";

  final String name;
  final String type;
  final String parameterName;
  final List<FilterValue> values;
  final List<String> numericValues;

  const Filter({this.name, this.type, this.parameterName, this.values, this.numericValues});

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(name: json['name'], type: json['type'], parameterName: json['parameter_name'], values: [
      if (json['value'] != null && json['parameter_name'] != PRICE)
        for (final value in json['value']) FilterValue.fromJson(value)
    ], numericValues: [
      if (json['value'] != null && json['parameter_name'] == PRICE) for (final value in json['value']) value
    ]);
  }
}

class FilterValue {
  final String id;
  final String value;

  const FilterValue({this.id, this.value});

  factory FilterValue.fromJson(Map<String, dynamic> json) {
    return FilterValue(id: json['id'], value: json['value']);
  }
}
