import 'package:refashioned_app/models/status.dart';

class CatalogResponse {
  final Status status;
  final List<Catalog> catalogs;

  const CatalogResponse({this.status, this.catalogs});

  factory CatalogResponse.fromJson(Map<String, dynamic> json) {
    return CatalogResponse(status: Status.fromJson(json['status']), catalogs: [
      for (final catalog in json['content']) Catalog.fromJson(catalog)
    ]);
  }
}

class Catalog {
  final String id;
  final String name;

  const Catalog({this.id, this.name});

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(id: json['id'], name: json['name']);
  }

  String get getId => id;

  String get getName => name;
}
