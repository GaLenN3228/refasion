import 'package:refashioned_app/models/status.dart';

class CategoryResponse {
  final Status status;
  final List<Category> categories;

  const CategoryResponse({this.status, this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
        status: Status.fromJson(json['status']),
        categories: [for (final category in json['content']) Category.fromJson(category)]);
  }
}

class Category {
  final String id;
  final String name;
  final List<Category> children;

  const Category({this.id, this.name, this.children});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name'], children: [
      if (json['children'] != null) for (final child in json['children']) Category.fromJson(child)
    ]);
  }

  String get getId => id;

  String get getName => name;
}
