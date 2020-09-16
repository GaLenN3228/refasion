import 'package:refashioned_app/models/status.dart';

class Category {
  final String id;
  final String name;
  final List<Category> children;
  final String image;

  bool selected;

  Category({this.image, this.id, this.name, this.children, this.selected = false});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'],
        image: (json['image'] != null) ? json['image'] : null,
        children: [
          if (json['children'] != null)
            for (final child in json['children']) Category.fromJson(child)
        ]);
  }

  factory Category.clone(Category other) =>
      Category(id: other.id, name: other.name, children: other.children, selected: other.selected);

  updateChild(String id) => children.firstWhere((child) => child.id == id).update();

  update() {
    selected = !selected;
  }

  reset() {
    selected = false;
  }

  String get getId => id;

  String get getName => name;

  String getRequestParameters() =>
      "?p=" +
      (children.where((category) => category.selected).isNotEmpty
          ? children.where((category) => category.selected).map((category) => category.id).join(',')
          : id);
}
