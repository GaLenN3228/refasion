import 'package:refashioned_app/models/filter.dart';

class QuickFilter {
  final String name;
  final QuickFilterValue values;

  bool selected;

  QuickFilter({this.name, this.values, this.selected: false});

  update() {
    selected = !selected;
  }

  factory QuickFilter.fromJson(Map<String, dynamic> json) {
    return QuickFilter(name: json['name'], values: QuickFilterValue.fromJson(json['values']));
  }
}

class QuickFilterValue {
  final String id;
  final List<int> price;

  bool selected;

  QuickFilterValue({this.id, this.price, this.selected: false});

  factory QuickFilterValue.fromJson(Map<String, dynamic> json) => QuickFilterValue(
      id: json['id'] != null ? json['id'].toString() : null,
      price: json['price'] != null ? [for (final price in json['price']) price] : null);
}
