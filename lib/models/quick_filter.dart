import 'package:refashioned_app/models/status.dart';

class QuickFiltersResponse {
  final Status status;
  final List<QuickFilter> content;

  const QuickFiltersResponse({this.status, this.content});

  factory QuickFiltersResponse.fromJson(Map<String, dynamic> json) {
    return QuickFiltersResponse(
        status: Status.fromJson(json['status']),
        content: [if (json['content'] != null) for (final filter in json['content']) QuickFilter.fromJson(filter)]);
  }
}

class QuickFilter {
  final String name;
  final String urlParams;

  bool selected;

  QuickFilter({this.name, this.urlParams, this.selected: false});

  update() {
    selected = !selected;
  }

  factory QuickFilter.fromJson(Map<String, dynamic> json) {
    return QuickFilter(name: json['name'], urlParams: json['url_params']);
  }
}
