import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/models/category.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        category.id.toString(),
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text('${category.name}'),
      isThreeLine: true,
      subtitle: Text(category.name),
      dense: true,
    );
  }
}