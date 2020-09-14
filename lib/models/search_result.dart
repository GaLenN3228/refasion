import 'package:refashioned_app/models/status.dart';

class SearchResultContent {
  final List<SearchResult> results;

  SearchResultContent({this.results});

  factory SearchResultContent.fromJson(Map<String, dynamic> json) {
    return SearchResultContent(results: [
      if (json['results'] != null)
        for (final result in json['results']) SearchResult.fromJson(result)
    ]);
  }
}

class SearchResult {
  final String id;
  final String model;
  final String name;
  final ExtraData extraData;

  SearchResult({this.extraData, this.id, this.model, this.name});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
        extraData: json['extra_data'] != null ? ExtraData.fromJson(json['extra_data']) : null,
        id: json['id'],
        model: json['model'],
        name: json['name']);
  }
}

class ExtraData {
  final String image;

  ExtraData({this.image});

  factory ExtraData.fromJson(Map<String, dynamic> json) {
    return ExtraData(image: json['image']);
  }
}
