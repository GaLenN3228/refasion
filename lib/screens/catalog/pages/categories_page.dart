import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/catalog/content/categories_page_content.dart';
import 'package:refashioned_app/screens/components/nav_panel.dart';
import 'package:refashioned_app/screens/components/search_panel.dart';

class CategoriesPage extends StatelessWidget {
  final Category parentCategory;

  const CategoriesPage({Key key, this.parentCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CategoriesPageContent(parentCategory: parentCategory)),
          Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: SearchPanel(
                withArrowBack: parentCategory != null,
              )),
          Positioned(left: 0, right: 0, bottom: 0, child: NavPanel())
        ],
      ),
    );
  }
}
