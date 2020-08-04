import 'package:refashioned_app/models/status.dart';

class CategoryResponse {
  final Status status;
  final List<Category> categories;

  const CategoryResponse({this.status, this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final categories = [for (final category in json['content']) Category.fromJson(category)];

    return CategoryResponse(
      status: Status.fromJson(json['status']),
      categories: categories
    );
  }
}

class Category {
  final String id;
  final String name;
  final List<Category> children;

  bool selected;

  Category({this.id, this.name, this.children, this.selected = false});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'],
        children: [if (json['children'] != null) for (final child in json['children']) Category.fromJson(child)]);
  }

  update() {
    selected = !selected;
  }

  reset() {
    selected = false;
  }

  String get getId => id;

  String get getName => name;
}
