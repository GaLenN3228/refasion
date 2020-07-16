import 'package:refashioned_app/models/status.dart';

class SearchResultResponse {
  final Status status;
  final SearchResultContent content;

  const SearchResultResponse({this.status, this.content});

  factory SearchResultResponse.fromJson(Map<String, dynamic> json) {
    return SearchResultResponse(
        status: Status.fromJson(json['status']), content: SearchResultContent.fromJson(json['content']));
  }
}

class SearchResultContent {
  final List<SearchResult> results;

  SearchResultContent({this.results});

  factory SearchResultContent.fromJson(Map<String, dynamic> json) {
    return SearchResultContent(
        results: [if (json['results'] != null) for (final result in json['results']) SearchResult.fromJson(result)]);
  }
}

class SearchResult {
  final String id;
  final String model;
  final String name;

  SearchResult({this.id, this.model, this.name});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(id: json['id'], model: json['model'], name: json['name']);
  }
}
