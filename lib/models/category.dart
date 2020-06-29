import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String children;

  Category({this.id, this.name, this.children}) : super([id, name, children]);

  @override
  String toString() => 'Category { id: $id, name: $name }';
}