import 'package:refashioned_app/models/status.dart';

class FiltersResponse {
  final Status status;
  final List<Filter> content;

  const FiltersResponse({this.status, this.content});

  factory FiltersResponse.fromJson(Map<String, dynamic> json) {
    return FiltersResponse(
        status: Status.fromJson(json['status']), content: [if (json['content'] != null) for (final filter in json['content']) Filter.fromJson(filter)]);
  }
}

class Filter {
  final String name;
  final String type;
  final String parameterName;
  final List<String> values;

  const Filter({this.name, this.type, this.parameterName, this.values});

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
        name: json['name'],
        type: json['type'],
        parameterName: json['parameter_name'],
        values: [if (json['value'] != null) for (final value in json['value']) value.toString()]
    );
  }
}