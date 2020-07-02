import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/components/catalog_brands.dart';
import 'package:refashioned_app/screens/catalog/components/catalog_divider.dart';
import 'package:refashioned_app/screens/catalog/components/catalog_image.dart';
import '../../../models/catalog.dart';
import '../components/catalog_tile.dart';

class CategoryPageContent extends StatelessWidget {
  final Catalog catalog;

  const CategoryPageContent({Key key, this.catalog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = catalog.children;

    if (children.isEmpty)
      return Center(
        child: Text("Нет подкатегорий"),
      );

    final widgetsList = List<Widget>.from([
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [CatalogImage(), CatalogBrands()],
      ),
    ]..addAll(
        children.map((catalog) => CatalogTile(catalog: catalog)).toList()));

    return ListView.separated(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 44 + 20, bottom: 100),
      itemCount: widgetsList.length,
      itemBuilder: (context, index) {
        return widgetsList.elementAt(index);
      },
      separatorBuilder: (context, index) {
        return CatalogDivider();
      },
    );
  }
}
