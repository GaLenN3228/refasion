import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/catalog/content/category_page_content.dart';
import 'package:refashioned_app/screens/components/nav_panel.dart';
import 'package:refashioned_app/screens/components/search_panel.dart';

class CategoryPage extends StatelessWidget {
  final Category category;

  const CategoryPage({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CategoryPageContent(category: category)),
          Positioned(
              left: 0,
              top: MediaQuery.of(context).padding.top,
              right: 0,
              child: SearchPanel()),
          Positioned(left: 0, right: 0, bottom: 0, child: NavPanel())
        ],
      ),
    );
  }
}
