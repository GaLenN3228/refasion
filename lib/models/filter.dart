import 'package:refashioned_app/models/status.dart';
import 'dart:math' as math;

enum Parameter { color, material, price, condition, size, undefined, brand }

class Filter {
  final String name;
  final String type;

  final Map<String, double> previousPrices;
  final Map<String, double> prices;

  final List<FilterValue> previousValues;
  final List<FilterValue> values;

  final Parameter parameter;

  bool modified = false;
  bool modifiedMin = false;
  bool modifiedMax = false;
  int selectedValuesCount = 0;

  Filter(
      {this.previousValues,
      this.previousPrices,
      this.parameter,
      this.name,
      this.type,
      this.values,
      this.prices});

  static const _parameters = {
    "color": Parameter.color,
    "material": Parameter.material,
    "price": Parameter.price,
    "condition": Parameter.condition,
    "size": Parameter.size,
    "brand": Parameter.brand,
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
        final prices = [for (final value in jsonValue) double.parse(value.toString())];

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

      case Parameter.brand:
        final values = [
          for (final value in jsonValue) FilterValue.fromJson(value, parameter: Parameter.brand)
        ];

        return Filter(
            name: json['name'],
            type: json['type'],
            parameter: parameter,
            previousValues: values.map((e) => FilterValue.clone(e)).toList(),
            values: List.from(values),
            previousPrices: null,
            prices: null);

      case Parameter.size:
        final values = [
          for (final value in jsonValue)
            if (value['code'].toString().contains("RU"))
              for (final sizeValue in value['values'])
                FilterValue.fromJson(sizeValue)
        ];

        return Filter(
            name: json['name'],
            type: json['type'],
            parameter: parameter,
            previousValues: values.map((e) => FilterValue.clone(e)).toList(),
            values: List.from(values),
            previousPrices: null,
            prices: null);

      default:
        final values = [for (final value in jsonValue) FilterValue.fromJson(value)];

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
        modifiedMin = prices.containsKey('lower');
        modifiedMax = prices.containsKey('upper');
        break;

      default:
        selectedValuesCount = values.where((value) => value.selected).length;
        break;
    }
    modified = selectedValuesCount != 0 || modifiedMin || modifiedMax;
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
        if (lower != null) {
          if (lower > prices['min'])
            prices['lower'] = lower;
          else
            prices.remove('lower');
        }

        if (upper != null) {
          if (upper < prices['max'])
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

  factory FilterValue.fromJson(Map<String, dynamic> json, {Parameter parameter}) {
    if (parameter != null) {
      switch (parameter) {
        case Parameter.brand:
          return FilterValue(id: json['id'], value: json['name']);
        default:
          return FilterValue(id: json['id'], value: json['value']);
      }
    } else
      return FilterValue(id: json['id'], value: json['value']);
  }

  factory FilterValue.clone(FilterValue other) =>
      FilterValue(id: other.id, value: other.value, selected: other.selected);

  update() {
    selected = !selected;
  }

  reset() {
    selected = false;
  }

  @override
  String toString() => "Filter Value: " + value + ", selected: " + selected.toString();
}
