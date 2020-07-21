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

  final Map<String, double> previousPrices;
  final Map<String, double> prices;

  final List<FilterValue> previousValues;
  final List<FilterValue> values;

  final Parameter parameter;
  bool modified = false;

  Filter(
      {this.previousValues,
      this.previousPrices,
      this.parameter,
      this.name,
      this.type,
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
    final parameter = _parameters[json['parameter_name']];

    final jsonValue = json['value'];

    if (jsonValue == null)
      return Filter(
          name: json['name'],
          type: json['type'],
          parameter: parameter,
          previousValues: null,
          values: null,
          previousPrices: null,
          prices: null);

    switch (parameter) {
      case Parameter.price:
        final prices = [
          for (final value in jsonValue) double.parse(value.toString())
        ];

        final min = prices.reduce(math.min);
        final max = prices.reduce(math.max);
        final map = {'min': min, 'max': max};

        return Filter(
            name: json['name'],
            type: json['type'],
            parameter: parameter,
            previousValues: null,
            values: null,
            previousPrices: Map.from(map),
            prices: Map.from(map));

      default:
        final values = [
          for (final value in jsonValue) FilterValue.fromJson(value)
        ];

        return Filter(
            name: json['name'],
            type: json['type'],
            parameter: parameter,
            previousValues: values.map((e) => FilterValue.clone(e)).toList(),
            values: List.from(values),
            previousPrices: null,
            prices: null);
    }
  }

  isModified() {
    switch (parameter) {
      case Parameter.price:
        modified = prices.containsKey('lower') || prices.containsKey('upper');
        break;

      default:
        modified =
            values.where((filterValue) => filterValue.selected).isNotEmpty;
        break;
    }
  }

  save() {
    switch (parameter) {
      case Parameter.price:
        previousPrices
          ..clear()
          ..addAll(prices);

        break;

      default:
        previousValues
          ..clear()
          ..addAll(values.map((e) => FilterValue.clone(e)).toList());

        break;
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
        }

        break;

      default:
        if (id != null && id.isNotEmpty)
          values.firstWhere((filterValue) => filterValue.id == id).update();

        break;
    }

    isModified();
  }

  reset({bool toPrevious: false}) {
    switch (parameter) {
      case Parameter.price:
        if (toPrevious)
          prices
            ..clear()
            ..addAll(previousPrices);
        else
          prices..remove('lower')..remove('upper');

        break;

      default:
        if (toPrevious)
          values
            ..clear()
            ..addAll(previousValues.map((e) => FilterValue.clone(e)).toList());
        else
          values.forEach((filterValue) => filterValue.reset());

        break;
    }

    isModified();
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

  factory FilterValue.fromJson(Map<String, dynamic> json) =>
      FilterValue(id: json['id'], value: json['value']);

  factory FilterValue.clone(FilterValue other) =>
      FilterValue(id: other.id, value: other.value, selected: other.selected);

  update() {
    selected = !selected;
  }

  reset() {
    selected = false;
  }

  @override
  String toString() =>
      "Filter Value: " + value + ", selected: " + selected.toString();
}
