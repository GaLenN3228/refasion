import 'package:refashioned_app/models/status.dart';
import 'dart:math' as math;

class FiltersResponse {
  final Status status;
  final List<Filter> content;

  const FiltersResponse({this.status, this.content});

  factory FiltersResponse.fromJson(Map<String, dynamic> json) {
    return FiltersResponse(status: Status.fromJson(json['status']), content: [
      if (json['content'] != null)
        for (final filter in json['content']) Filter.fromJson(filter)
    ]);
  }
}

enum Parameter { color, material, price, condition, size, undefined }

class Filter {
  final String name;
  final String type;
  final String parameterName;
  final List<FilterValue> values;
  final Map<String, double> prices;

  final Parameter parameter;
  bool modified = false;

  Filter(
      {this.parameter,
      this.name,
      this.type,
      this.parameterName,
      this.values,
      this.prices});

  static const _parameters = {
    "Цвет": Parameter.color,
    "Материал": Parameter.material,
    "Цена": Parameter.price,
    "Состояние": Parameter.condition,
    "Размер": Parameter.size,
    null: Parameter.undefined
  };

  factory Filter.fromJson(Map<String, dynamic> json) {
    final parameterName = json['parameter_name'];
    final parameter = _parameters[parameterName];

    final jsonValue = json['value'];

    if (jsonValue == null)
      return Filter(
          name: json['name'],
          type: json['type'],
          parameterName: parameterName,
          parameter: _parameters[parameterName],
          values: null,
          prices: null);

    switch (parameter) {
      case Parameter.price:
        final prices = [
          for (final value in jsonValue) double.parse(value.toString())
        ];

        final min = prices.reduce(math.min);
        final max = prices.reduce(math.max);

        return Filter(
            name: json['name'],
            type: json['type'],
            parameterName: parameterName,
            parameter: parameter,
            values: null,
            prices: {'min': min, 'max': max});

      default:
        final values = [
          for (final value in jsonValue) FilterValue.fromJson(value)
        ];

        return Filter(
            name: json['name'],
            type: json['type'],
            parameterName: parameterName,
            parameter: parameter,
            values: values,
            prices: null);
    }
  }

  update({String id, double lower, double upper}) {
    switch (parameter) {
      case Parameter.price:
        if (lower != null && upper != null) {
          if (lower != prices['min'])
            prices['lower'] = lower;
          else
            prices.remove('lower');

          if (upper != prices['max'])
            prices['upper'] = upper;
          else
            prices.remove('upper');

          modified = prices.containsKey('lower') || prices.containsKey('upper');
        }
        break;

      default:
        if (id != null && id.isNotEmpty)
          values.firstWhere((filterValue) => filterValue.id == id).update();

        modified =
            values.where((filterValue) => filterValue.selected).isNotEmpty;
        break;
    }
  }

  reset() {
    switch (parameter) {
      case Parameter.price:
        prices.remove('lower');
        prices.remove('upper');

        modified = prices.containsKey('lower') || prices.containsKey('upper');
        break;

      default:
        values.forEach((filterValue) => filterValue.reset());

        modified =
            values.where((filterValue) => filterValue.selected).isNotEmpty;
        break;
    }
  }

  String getRequestParameters() {
    if (!modified) return "";

    switch (parameter) {
      case Parameter.price:
        var newParameters = "";

        if (prices.containsKey('lower'))
          newParameters += "&min_price=" + prices['lower'].toInt().toString();

        if (prices.containsKey('upper'))
          newParameters += "&max_price=" + prices['upper'].toInt().toString();

        return newParameters;

      default:
        final selectedIdList = values
            .where((filterValue) => filterValue.selected)
            .map((filterValue) => filterValue.id);

        if (selectedIdList.isNotEmpty)
          return "&p=" + selectedIdList.join(',');
        else
          return "";
    }
  }
}

class FilterValue {
  final String id;
  final String value;

  bool selected;

  FilterValue({this.id, this.value, this.selected: false});

  factory FilterValue.fromJson(Map<String, dynamic> json) {
    return FilterValue(id: json['id'], value: json['value']);
  }

  update() {
    selected = !selected;
  }

  reset() {
    selected = false;
  }
}
