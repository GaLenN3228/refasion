import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/content/catalog_page_content.dart';
import 'package:refashioned_app/screens/components/nav_panel.dart';
import 'package:refashioned_app/screens/components/search_panel.dart';

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CatalogPageContent()),
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
